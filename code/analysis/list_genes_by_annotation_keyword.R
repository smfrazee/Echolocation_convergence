# Install and load necessary packages
if (!requireNamespace("GO.db", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("GO.db")
BiocManager::install("AnnotationDbi")
BiocManager::install("org.Hs.eg.db")  # Replace with your organism's database if needed

library(GO.db)
library(AnnotationDbi)
library(org.Hs.eg.db)

# Step 1: Search for GO terms that match the keywords "hearing", "sound", or "auditory"
keywords <- c("hearing", "sound", "auditory")

# Get all GO terms from GO.db
go_terms <- as.list(GO.db::GOTERM)

# Search for matching GO terms based on keywords in their descriptions
matching_go_terms <- sapply(go_terms, function(x) {
  # Get the term description using Term()
  term_description <- Term(x)
  
  # Check if any of the keywords match the term description
  any(sapply(keywords, function(keyword) grepl(keyword, term_description, ignore.case = TRUE)))
})

# Extract the GO IDs that match the keywords
matching_go_ids <- names(matching_go_terms[matching_go_terms])

# Step 2: Get the genes associated with the matching GO terms
# Use the org.Hs.eg.db package to retrieve gene IDs for the matching GO terms
gene_associations <- select(org.Hs.eg.db, keys = matching_go_ids, columns = c("ENSEMBL", "SYMBOL"), keytype = "GO")

# Display the results
head(gene_associations)

