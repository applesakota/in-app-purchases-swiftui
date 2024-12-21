//
//  SmootiheDring.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/17/24.
//

import Foundation


struct SmoothieDrink: Identifiable, Hashable {
    
    //MARK: - Globals
    
    let id: String
    let name: String
    let description: String
    
    static let strawberryBanana = SmoothieDrink(
        id: "StrawberryBanana",
        name: "Strawberry Banana",
        description: "A classic smoothie with fresh strawberries and ripe bananas."
    )
    
    static let mangoPineapple = SmoothieDrink(
        id: "MangoPineapple",
        name: "Mango Pineapple",
        description: "Tropical flavors with sweet mangoes and tangy pineapple."
    )
    
    static let blueberryBliss = SmoothieDrink(
        id: "BlueberryBliss",
        name: "Blueberry Bliss",
        description: "Packed with antioxidants from fresh blueberries."
    )
    
    static let greenDetox = SmoothieDrink(
        id: "GreenDetox",
        name: "Green Detox",
        description: "A refreshing blend of spinach, kale, and apple for a healthy detox."
    )
    
    static let chocolatePeanutButter = SmoothieDrink(
        id: "ChocolatePeanutButter",
        name: "Chocolate Peanut Butter",
        description: "Rich chocolate with creamy peanut butter for a decadent treat."
    )
    
    static let tropicalSunrise = SmoothieDrink(
        id: "TropicalSunrise",
        name: "Tropical Sunrise",
        description: "Bright and refreshing blend of orange, pineapple, and mango."
    )
    
    static let berryBlast = SmoothieDrink(
        id: "BerryBlast",
        name: "Berry Blast",
        description: "A burst of berries, including strawberries, blueberries, and raspberries."
    )
    
    static let peachPerfection = SmoothieDrink(
        id: "PeachPerfection",
        name: "Peach Perfection",
        description: "Sweet peaches blended with yogurt for a creamy delight."
    )
    
    static let coconutParadise = SmoothieDrink(
        id: "CoconutParadise",
        name: "Coconut Paradise",
        description: "A tropical escape with coconut milk, pineapple, and banana."
    )
    
    static let avocadoDream = SmoothieDrink(
        id: "AvocadoDream",
        name: "Avocado Dream",
        description: "Smooth and creamy avocado with a touch of honey and lime."
    )
    
    static let almondJoy = SmoothieDrink(
        id: "AlmondJoy",
        name: "Almond Joy",
        description: "Almond butter, almond milk, and a hint of cocoa for a nutty indulgence."
    )
    
    static let raspberryLemonade = SmoothieDrink(
        id: "RaspberryLemonade",
        name: "Raspberry Lemonade",
        description: "A tangy mix of fresh raspberries and lemon juice."
    )
    
    static let carrotGinger = SmoothieDrink(
        id: "CarrotGinger",
        name: "Carrot Ginger",
        description: "Earthy carrots blended with spicy ginger for a zesty kick."
    )
    
    static let bananaOat = SmoothieDrink(
        id: "BananaOat",
        name: "Banana Oat",
        description: "A hearty smoothie with oats, bananas, and almond milk."
    )
    
    static let mintyMelon = SmoothieDrink(
        id: "MintyMelon",
        name: "Minty Melon",
        description: "Cool and refreshing blend of watermelon and mint."
    )
    
    static func allSmoothies() -> [SmoothieDrink] {
        
        return [
            strawberryBanana, mangoPineapple, blueberryBliss, greenDetox, chocolatePeanutButter,
            tropicalSunrise, berryBlast, peachPerfection, coconutParadise, avocadoDream,
            almondJoy, raspberryLemonade, carrotGinger, bananaOat, mintyMelon
        ]
    }
    
    func imageFile() -> String {
        guard name == "Strawberry Banana" || name == "Coconut Paradise" || name == "Berry Blast" else {
            return ""
        }
        
        return name
    }
}

// MARK: - Recipes

extension SmoothieDrink {
    
    static var empty: SmoothieDrink {
        get {
            return .init(id: "", name: "", description: "")
        }
    }
    
    static func recipes() -> [SmoothieDrink: String] {
        [
            .strawberryBanana: """
                    # Our Signature Strawberry Banana Smoothie Recipe
                    
                    Experience the fresh and fruity flavor of our signature Strawberry Banana smoothie. Follow these simple steps to create a refreshing drink packed with natural sweetness and nutrients.
                    
                    ## Ingredients
                    - 1 cup fresh strawberries
                    - 1 ripe banana
                    - 1/2 cup plain Greek yogurt
                    - 1/2 cup almond milk
                    - 1 tablespoon honey (optional)
                    - Ice cubes (optional)
                    
                    ## Instructions
                    1. **Prepare the ingredients**: Hull the strawberries and peel the banana.
                    2. **Blend everything**: Add all ingredients to a blender and blend until smooth.
                    3. **Adjust consistency**: Add ice cubes for a thicker smoothie if needed.
                    4. **Serve and enjoy**: Pour into a glass and enjoy fresh!
                    
                    ## Tips
                    - Use frozen fruit for a thicker, colder smoothie.
                    """,
            
                .mangoPineapple: """
                    # Our Signature Mango Pineapple Smoothie Recipe
                    
                    Enjoy the taste of the tropics with this vibrant Mango Pineapple smoothie.
                    
                    ## Ingredients
                    - 1 cup ripe mango chunks
                    - 1/2 cup pineapple chunks
                    - 1/2 cup coconut milk
                    - 1/4 cup orange juice
                    - Ice cubes (optional)
                    
                    ## Instructions
                    1. **Prepare the ingredients**: Chop fresh mango and pineapple.
                    2. **Blend everything**: Blend all ingredients until smooth.
                    3. **Serve and enjoy**: Pour into a chilled glass and enjoy!
                    
                    ## Tips
                    - Garnish with shredded coconut or a pineapple slice.
                    """,
            
                .blueberryBliss: """
                    # Our Signature Blueberry Bliss Smoothie Recipe
                    
                    Enjoy the antioxidant-rich flavors of our Blueberry Bliss smoothie.
                    
                    ## Ingredients
                    - 1 cup fresh or frozen blueberries
                    - 1/2 banana
                    - 1/2 cup almond milk
                    - 1/4 cup Greek yogurt
                    - 1 tablespoon honey (optional)
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Adjust texture** with ice cubes if needed.
                    3. **Serve and enjoy**.
                    
                    ## Tips
                    - Add chia seeds or flaxseeds for extra nutrition.
                    """,
            .greenDetox: """
                    # Our Signature Green Detox Smoothie Recipe
                    
                    Cleanse your body with our refreshing Green Detox smoothie.
                    
                    ## Ingredients
                    - 1 cup spinach
                    - 1/2 cup kale
                    - 1 apple, cored and chopped
                    - 1/2 banana
                    - 1 tablespoon lemon juice
                    - 1/2 cup water or coconut water
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add ginger for extra detox power.
                    """,
            
                .chocolatePeanutButter: """
                    # Our Signature Chocolate Peanut Butter Smoothie Recipe
                    
                    Indulge in this rich and creamy Chocolate Peanut Butter smoothie.
                    
                    ## Ingredients
                    - 1 tablespoon peanut butter
                    - 1 tablespoon cocoa powder
                    - 1/2 banana
                    - 1/2 cup almond milk
                    - 1 tablespoon honey
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add protein powder for a post-workout boost.
                    """,
            
                .tropicalSunrise: """
                    # Our Signature Tropical Sunrise Smoothie Recipe
                    
                    Start your day with a refreshing Tropical Sunrise smoothie.
                    
                    ## Ingredients
                    - 1/2 cup orange juice
                    - 1/2 cup pineapple chunks
                    - 1/2 cup mango chunks
                    - 1/2 banana
                    
                    ## Instructions
                    1. **Blend everything** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add coconut water for extra hydration.
                    """,
            
                .berryBlast: """
                    # Our Signature Berry Blast Smoothie Recipe
                    
                    A blend of berries for a powerful antioxidant boost.
                    
                    ## Ingredients
                    - 1/2 cup strawberries
                    - 1/2 cup blueberries
                    - 1/4 cup raspberries
                    - 1/2 cup almond milk
                    - 1 tablespoon honey (optional)
                    
                    ## Instructions
                    1. **Blend everything** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Use frozen berries for a thicker smoothie.
                    """,
            
                .peachPerfection: """
                    # Our Signature Peach Perfection Smoothie Recipe
                    
                    Sweet, creamy, and refreshing, this smoothie is a peach lover’s dream.
                    
                    ## Ingredients
                    - 1 ripe peach, chopped
                    - 1/2 cup Greek yogurt
                    - 1/2 cup almond milk
                    - 1 tablespoon honey
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add a handful of spinach for an extra nutrient boost.
                    """,
            
                .coconutParadise: """
                    # Our Signature Coconut Paradise Smoothie Recipe
                    
                    Indulge in this tropical coconut smoothie.
                    
                    ## Ingredients
                    - 1/2 cup coconut milk
                    - 1/2 banana
                    - 1/2 cup pineapple chunks
                    - 1 tablespoon shredded coconut
                    
                    ## Instructions
                    1. **Blend everything** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add mango for extra sweetness.
                    """,
            .avocadoDream: """
                    # Our Signature Avocado Dream Smoothie Recipe
                    
                    Creamy and rich, this avocado smoothie is both healthy and indulgent.
                    
                    ## Ingredients
                    - 1/2 avocado
                    - 1/2 banana
                    - 1/2 cup almond milk
                    - 1 tablespoon honey
                    - Ice cubes (optional)
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add spinach for an extra green boost.
                    """,
            
                .almondJoy: """
                    # Our Signature Almond Joy Smoothie Recipe
                    
                    Nutty and sweet, this Almond Joy smoothie is perfect for a healthy treat.
                    
                    ## Ingredients
                    - 1 tablespoon almond butter
                    - 1 tablespoon cocoa powder
                    - 1/2 cup almond milk
                    - 1/2 banana
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add a dash of vanilla extract for extra flavor.
                    """,
            
                .raspberryLemonade: """
                    # Our Signature Raspberry Lemonade Smoothie Recipe
                    
                    Tart and sweet, this Raspberry Lemonade smoothie is perfect for hot days.
                    
                    ## Ingredients
                    - 1/2 cup raspberries
                    - 1/4 cup lemon juice
                    - 1 tablespoon honey
                    - 1/2 cup water or coconut water
                    - Ice cubes
                    
                    ## Instructions
                    1. **Blend everything** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Garnish with a lemon slice for presentation.
                    """,
            
                .carrotGinger: """
                    # Our Signature Carrot Ginger Smoothie Recipe
                    
                    This smoothie blends sweet carrots with zesty ginger for a refreshing drink.
                    
                    ## Ingredients
                    - 1 large carrot, peeled and chopped
                    - 1/2 inch ginger, peeled and chopped
                    - 1/2 cup orange juice
                    - 1/2 banana
                    
                    ## Instructions
                    1. **Blend everything** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add turmeric for an anti-inflammatory boost.
                    """,
            
                .bananaOat: """
                    # Our Signature Banana Oat Smoothie Recipe
                    
                    A hearty, energy-boosting smoothie perfect for breakfast.
                    
                    ## Ingredients
                    - 1/2 cup rolled oats
                    - 1 banana
                    - 1/2 cup almond milk
                    - 1 tablespoon honey
                    
                    ## Instructions
                    1. **Blend all ingredients** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Add a spoonful of peanut butter for extra protein.
                    """,
            .mintyMelon: """
                    # Our Signature Minty Melon Smoothie Recipe
                    
                    Cool and refreshing, this Minty Melon smoothie is perfect for summer.
                    
                    ## Ingredients
                    - 1 cup watermelon chunks
                    - 1/4 cup fresh mint leaves
                    - 1/2 cup coconut water
                    - Ice cubes
                    
                    ## Instructions
                    1. **Blend everything** until smooth.
                    2. **Serve and enjoy**.
                    
                    ## Tips
                    - Garnish with extra mint leaves for a refreshing twist.
                    """
        ]
    }
}
