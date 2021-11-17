#!/home/k-hashi/osc-fs/bin/ruby

	TEMP_BED = "/tmp/XXXXXX"
	def run1(command, ver=false)
		results = ""
		warn command+"\n" if(ver)
		IO.popen(command).each {|line| results = line}
		return results.chomp
	end

    p ARGV
    param = ARGV.shift
    print "param: ",param,"\n"

if(param=="0") then
## ---- #01 brief annotation bed12 files (hierachical clustering ---- ## (2012/06/18)
# command: ../../01_work.rb *.0.bed
	outSuffix = ".1.bed"
#	ANN    = "/home/k-hashi/osc-fs/DATA/ANN/mm9_ensembl.bed"
#	ANN_EX = "/home/k-hashi/osc-fs/DATA/ANN/mm9_ensembl_EXON.bed"
#	ANN_RE = "/home/k-hashi/osc-fs/DATA/ANN/mm9_rmsk.bed" # for others
	ANN    = "/home/k-hashi/osc-fs/DATA/ANN/mm10_gencodeM4.bed"
	ANN_EX = "/home/k-hashi/osc-fs/DATA/ANN/mm10_gencodeM4.EXON.bed"
	ANN_RE = "/home/k-hashi/osc-fs/DATA/ANN/mm10_rmsk.bed" # for others
	namesRNA = [
				["rRNA:","rRNA",ANN_RE,"-s"], ["tRNA:","tRNA",ANN_RE,"-s"], ["snRNA:","snRNA",ANN_RE,"-s"], ["snoRNA:","snoRNA",ANN_EX,"-s"], ["protein_coding:","coding_exon",ANN_EX,"-s"],
				["lincRNA:","lincRNA_exon",ANN_EX,"-s"],  [":","other_exon",ANN_EX,"-s"], [":","antisense",ANN_EX,"-S"], 
				[":","intron",ANN,""]
			]
	namesDNA = [
				["rRNA:","rRNA",ANN_RE,"-s"], ["snoRNA:","snoRNA",ANN_EX,"-s"], ["protein_coding:","coding_exon",ANN_EX,"-s"],
				["lincRNA:","lincRNA_exon",ANN_EX,"-s"], [":","other_exon",ANN_EX,"-s"], [":","antisense",ANN_EX,"-S"], 
				[":","intron",ANN,""]
			]

	bedFiles = ARGV
	bedFiles.each {|bedFile|
		outFile = bedFile.sub(".0.bed",outSuffix)
		warn "###### ---- running " + bedFile + "... ---- ######\n"
		## split rna and dna parts
		rnaAllBed   = run1("mktemp " + TEMP_BED) ## create a temp file
		dnaAllBed   = run1("mktemp " + TEMP_BED) ## create a temp file
		rnaBed   = run1("mktemp " + TEMP_BED) ## create a temp file
		dnaBed   = run1("mktemp " + TEMP_BED) ## create a temp file
		command = <<-EOS
			cut -f1-6  #{bedFile} | awk '{n+=1;print $0"\\t"n}' > #{rnaBed}
			cut -f7-12 #{bedFile} | awk '{n+=1;print $0"\\t"n}' > #{dnaBed}
		EOS
		run1(command, true)

		## ---- annotation process for RNA ---- ##
		namesRNA.each {|values|
			key, name, file, strand = values
			remainBed   = run1("mktemp " + TEMP_BED)
			command = <<-EOS
				cat #{file} | awk '$4~/#{key}/' | intersectBed -a #{rnaBed} -b stdin #{strand} -u | \\
					awk '{print $0"\\t#{name}"}' >> #{rnaAllBed}
				cat #{file} | awk '$4~/#{key}/' | intersectBed -a #{rnaBed} -b stdin #{strand} -v >  #{remainBed}
				rm #{rnaBed}
			EOS
			run1(command, true)
			rnaBed = remainBed
		}
		command = <<-EOS
			cat #{rnaBed} | awk '{print $0"\\tintergenic"}' >> #{rnaAllBed};
			rm #{rnaBed}
		EOS
		run1(command, true)

		## ---- annotation process for DNA ---- ##
		namesDNA.each {|values|
			key, name, file, strand = values
			remainBed   = run1("mktemp " + TEMP_BED)
			command = <<-EOS
				cat #{file} | awk '$4~/#{key}/' | intersectBed -a #{dnaBed} -b stdin #{strand} -u | \\
					awk '{print $0"\\t#{name}"}' >> #{dnaAllBed}
				cat #{file} | awk '$4~/#{key}/' | intersectBed -a #{dnaBed} -b stdin #{strand} -v >  #{remainBed}
				rm #{dnaBed}
			EOS
			run1(command, true)
			dnaBed = remainBed
		}
		command = <<-EOS
			cat #{dnaBed} | awk '{print $0"\\tintergenic"}' >> #{dnaAllBed};
			rm #{dnaBed}
		EOS
		run1(command, true)

		## ---- merge RNA and DNA parts ---- ##
		tempR = run1("mktemp " + TEMP_BED)
		tempD = run1("mktemp " + TEMP_BED)
		command = <<-EOS
			sort -k7,7n #{rnaAllBed} > #{tempR}
			sort -k7,7n #{dnaAllBed} > #{tempD}
			join -j 7 #{tempR} #{tempD} | awk 'BEGIN{OFS="\\t"}{print $2,$3,$4,$5,$6,$7,$9,$10,$11,$12,$13,$14,$8,$15}' > #{outFile}
			wc -l #{bedFile}
			wc -l #{tempR}
			wc -l #{tempD}
			wc -l #{outFile}
			rm #{rnaAllBed} #{dnaAllBed} #{tempR} #{tempD}
		EOS
		IO.popen(command).each {|line| warn(line)}
	}
end

