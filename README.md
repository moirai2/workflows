# workflows
Download site for exchanging files with collaborators

## To Install/Download

Use git command to clone project to your computer.

```shell
$ git clone https://github.com/moirai2/workflows.git workflows
```
or you can click on "Code" and select "Download ZIP"

## Structure
```
workflows/
└── RADICL/ - tools/softwares for running for RADICL workflow
|   └── linux/ - Linux executable binaries
└── ssCAGE/ - tools/softwares for running for ssCAGE workflow
    └── linux/ - Linux executable binaries

## RADICL

- moirai default environment:
  - bwa  0.7.15-r1140
  - samtools 0.1.19-44428cd
  - tagdust2 2.33
  - tagdust 1.13
  - fastx_reverse_complement 0.0.13.2
  - fastuniq ?
  - rRNAdust 1.06
  - bamToBed  v2.27.1
  - STAR 2.7.1a

- mkato environment:
  - bwa  0.7.15-r1140
  - samtools 1.3.1
  - tagdust2 2.33
  - tagdust 1.13
  - fastx_reverse_complement 0.0.13.2
  - fastuniq ?
  - rRNAdust 1.06
  - bamToBed v2.26.0
  - STAR 2.5.2b