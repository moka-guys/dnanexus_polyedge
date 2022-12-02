# DNAnexus polyedge v1.0.0

Uses [polyedge v1.0.0](https://github.com/moka-guys/polyedge/tree/v1.0.0) to determine if a known variant is present at 
the base preceeding a poly stretch in a BAM file. Lists the count of each allele at that position, along with other 
metrics (detailed at [polyedge v1.0.0](https://github.com/moka-guys/polyedge/tree/v1.0.0)). This version identifies the 
pathogenic A>T SNV at +3 of intron 5 of the MSH2 gene. 

This provides a solution to the alignment issues caused by poly repeat stretches, whereby the aligner spreads the 
variant across adjacent bases and dilutes it to a point where the standard variant caller cannot detect it.

## Inputs
- `BAM` - BAM file
- `BAI` - BAM index file
- `skip` - boolean (default `true`)

## Outputs
- `*msh2_polyedge.txt` - file (output to `/MSH2_polyedge`)

`*msh2_polyedge.txt` is a  tab delimited file describing all alleles seen at that position. Please see the 
[polyedge readme](https://github.com/moka-guys/polyedge#output) for a more detailed description.

## How does this app work?
If skip is true the app closes without downloading any inputs. This allows us to embed the app in a generic workflow
that would run samples where MSH2 is not a gene of interest.

Otherwise, the app downloads the polyedge dockerfile from 001_ToolsReferenceData, and the input files, runs the docker, 
and captures the stdout into the output file.

### This app was produced by the Viapath Genome Informatics Team.