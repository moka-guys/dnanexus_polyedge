# DNAnexus PolyEdge

Uses [polyedge v1.1.0](https://github.com/moka-guys/polyedge) to find variants at the 5' end of a poly stretch of varying length in a BAM file. Lists the count of each allele at that position, along with other metrics (detailed at [polyedge v1.1.0](https://github.com/moka-guys/polyedge)).

This provides a solution to the alignment issues caused by poly repeat stretches, whereby the aligner spreads the variant across adjacent bases and dilutes it to a point where the standard variant caller cannot detect it.

## How does this app work?

If `skip` is `true` the app closes without downloading any inputs. This allows us to embed the app in a generic workflow that does not require the polyedge app.

Otherwise, the app downloads the polyedge dockerfile from 001_ToolsReferenceData, and the input files, runs the docker, and captures the stdout into the output file.

## Inputs

- `BAM` - BAM file
- `BAI` - BAM index file
- `gene` - Gene of interest
- `poly_start` - Start position of poly stretch (0-based)
- `poly_end` - End position of poly stretch (0-based)
- `chrom` - Chromosome of interest
- `anchor_length` - Length of anchor sequence (Default is 2. It is *NOT* recommended to change this from the default)
- `skip` - boolean (default `true`)

## Outputs

- `polyedge_csv` - CSV output with per-allele metrics
- `polyedge_pdf` - HTML output with per-allele metrics
- `polyedge_html` - PDF output with per-allele metrics

This array of files contains the following:

- CSV file containing raw data - `$SAMPLENAME.refined.$GENE_polyedge.csv`
- HTML report - `$SAMPLENAME.refined.$GENE_polyedge.html`
- PDF report - `$SAMPLENAME.refined.$GENE_polyedge.pdf`
  
These files describe the alleles seen at the position of interest (this position is the `poly_start` position, and whilst the app input is a 0-based coordinate, it is displayed in the output files as a 1-based coordinate). Further details on the output files can be found in the readme at [polyedge v1.1.0](https://github.com/moka-guys/polyedge).

### This app was produced by the Synnovis Genome Informatics Team
