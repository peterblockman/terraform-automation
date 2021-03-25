terraform {
  backend "remote" {
    organization = "peterlearner"

    workspaces {
      name = "peter-dev"
    }
  }
}