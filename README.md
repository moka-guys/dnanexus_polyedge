# DNAnexus polyedge v1.0.0

## What does this app do?
The app takes in a BAM file and uses [polyedge](https://github.com/moka-guys/polyedge/tree/v1.0.0) to list the count of each allele at the base preceeding a poly stretch. This release covers a specific position at the 5' end of intron 5 in MSH2  # TODO link to specific release
 
## What are typical use cases for this app?
It is used to determine if a known variant is present, getting around the alignment issues caused by a Poly repeat stretch.

## What inputs are required for this app to run?
- BAM file
- BAM index file
- skip (boolean flag - true (default) or false). If skip = true the app runs but finishes without any data processing. This is so we can embed the app in a generic workflow that would run more than just FH samples.

## How does this app work?
If skip is true the app closes without downloading any inputs.
Otherwise, the app downloads the input files (BAM/BAI) and the dockerfile containing the polyedge code (from 001_ToolsReferenceData).
The polyedge script is run and the stdout captured into the output file(s).

## What does this app output?
The standard out and stderror are each captured in thier own files.
The main output file (*msh2_polyedge.txt) is a tab seperated file describing all the alleles seen at that position, and the count of each. Please see the [polyedge readme](https://github.com/moka-guys/polyedge#output) for a more detailed description.
The stderror is saved to *_stderr.txt.
These files are output to `/MSH2_polyedge`

### This app was produced by the Viapath Genome Informatics Team.
