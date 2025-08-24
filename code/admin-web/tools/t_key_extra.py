import re
from pathlib import Path
from typing import Set, List

def extract_translation_keys(content: str) -> Set[str]:
    """Extract translation keys from the content using regex."""
    # Create a regex pattern that matches t('something') or t("something")
    pattern = re.compile(r"t\(['\"]([^'\"]+)['\"]\)")
    
    # Find all matches in the content
    matches = pattern.findall(content)
    return set(matches)

def process_vue_file(file_path: str) -> List[str]:
    """Process a Vue file and return found translation keys."""
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
        keys = extract_translation_keys(content)
        return sorted(list(keys))

def main():
    # Example file path - adjust as needed
    file_path = "YourComponent.vue"
    
    # Extract and print the translation keys
    found_keys = process_vue_file(file_path)
    
    print("Found translation keys:")
    for key in found_keys:
        print(f"- {key}")
    
    # Check for specific keys
    target_keys = {'common.companyNotFound', 'chat.dataFetchError'}
    found_target_keys = set(found_keys).intersection(target_keys)
    
    print("\nTarget keys found:")
    for key in target_keys:
        status = "✓" if key in found_target_keys else "✗"
        print(f"{status} {key}")

if __name__ == "__main__":
    main()