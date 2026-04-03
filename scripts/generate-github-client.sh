#!/bin/bash

# GitHub Client Code Generation Script
# This script generates Swift types and client code from the GitHub OpenAPI specification
# Usage: ./scripts/generate-github-client.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GITHUB_CLIENT_DIR="${PROJECT_DIR}/Sources/GitHubClient"
OUTPUT_DIR="${GITHUB_CLIENT_DIR}/Generated"
OPENAPI_SPEC="${GITHUB_CLIENT_DIR}/openapi.yml"
GENERATOR_CONFIG="${GITHUB_CLIENT_DIR}/openapi-generator-config.yml"

# Validate that required files exist
validate_files() {
  echo -e "${YELLOW}Validating required files...${NC}"

  if [[ ! -f "$OPENAPI_SPEC" ]]; then
    echo -e "${RED}✗ OpenAPI specification not found: $OPENAPI_SPEC${NC}"
    exit 1
  fi

  if [[ ! -f "$GENERATOR_CONFIG" ]]; then
    echo -e "${RED}✗ Generator configuration not found: $GENERATOR_CONFIG${NC}"
    exit 1
  fi

  echo -e "${GREEN}✓ All required files found${NC}"
}

# Create output directory if it doesn't exist
create_output_directory() {
  echo -e "${YELLOW}Setting up output directory...${NC}"

  mkdir -p "$OUTPUT_DIR"

  echo -e "${GREEN}✓ Output directory ready: $OUTPUT_DIR${NC}"
}

# Run the generator
run_generator() {
  echo -e "${YELLOW}Generating Swift client code from OpenAPI spec...${NC}"

  cd "$PROJECT_DIR"

  swift run swift-openapi-generator generate \
    --output-directory "$OUTPUT_DIR" \
    --config "$GENERATOR_CONFIG" \
    "$OPENAPI_SPEC"

  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✓ Code generation completed successfully${NC}"
  else
    echo -e "${RED}✗ Code generation failed${NC}"
    exit 1
  fi
}

# Verify generated files
verify_output() {
  echo -e "${YELLOW}Verifying generated files...${NC}"

  local files_generated=0

  if [[ -f "${OUTPUT_DIR}/Client.swift" ]]; then
    local size=$(du -h "${OUTPUT_DIR}/Client.swift" | cut -f1)
    echo -e "${GREEN}✓ Client.swift generated ($size)${NC}"
    ((files_generated++))
  else
    echo -e "${RED}✗ Client.swift not found${NC}"
  fi

  if [[ -f "${OUTPUT_DIR}/Types.swift" ]]; then
    local size=$(du -h "${OUTPUT_DIR}/Types.swift" | cut -f1)
    echo -e "${GREEN}✓ Types.swift generated ($size)${NC}"
    ((files_generated++))
  else
    echo -e "${RED}✗ Types.swift not found${NC}"
  fi

  if [[ $files_generated -lt 2 ]]; then
    echo -e "${RED}✗ Some expected files were not generated${NC}"
    exit 1
  fi
}

# Main execution
main() {
  echo -e "${GREEN}=== GitHub Client Code Generator ===${NC}"
  echo ""

  validate_files
  create_output_directory
  run_generator
  verify_output

  echo ""
  echo -e "${GREEN}=== Generation Complete ===${NC}"
  echo -e "Generated files location: ${YELLOW}${OUTPUT_DIR}${NC}"
}

main "$@"
