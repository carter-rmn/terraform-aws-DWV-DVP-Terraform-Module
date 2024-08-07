resource "aws_ecr_repository" "data_ecr_builder" {
  name                 = var.ecrname_builder
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "data_ecr_management" {
  name                 = var.ecrname_management
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "data_ecr_connector" {
  name                 = var.ecrname_connector
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "data_ecr_fe" {
  name                 = var.ecrname_fe
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "test_ecr_builder" {
  name                 = var.ecrname_test_builder
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "test_ecr_management" {
  name                 = var.ecrname_test_management
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "test_ecr_connector" {
  name                 = var.ecrname_test_connector
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "test_ecr_fe" {
  name                 = var.ecrname_test_fe
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "ecr_odin" {
  name                 = var.ecrname_odin
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "ecr_web" {
  name                 = var.ecrname_web
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "ecr_scheduler" {
  name                 = var.ecrname_scheduler
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_odin_executor_rmn" {
  name                 = var.ecrname_odin_executor_rmn
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "ecr_odin_web_rmn" {
  name                 = var.ecrname_odin_web_rmn
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "ecr_odin_scheduler_rmn" {
  name                 = var.ecrname_odin_scheduler_rmn
  image_tag_mutability = var.imagetag

  image_scanning_configuration {
    scan_on_push = true
  }
}