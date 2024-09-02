provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google" {
  alias   = "us_east"
  project = var.project_id
  region  = "us-east1"
}
