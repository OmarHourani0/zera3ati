import sys
sys.path.append('C:\\Users\\jacks\\anaconda3\\envs\\farmapp_env\\zera3ati\\farmapp_env\\myapp')
from newai import main

# Test the main function
if __name__ == "__main__":
    language = "en"  # or "ar"
    crops_list = ["Tomatoes", "Mushroom", "Basil", "Peas, green", "Broad beans, green"]
    specified_month = "February"
    
    results = main(language, crops_list, specified_month)
    
    for key, value in results.items():
        print(f"{key}:")
        for crop, price in value:
            print(f"  {crop}: {price}")
        print()
