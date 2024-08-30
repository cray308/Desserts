# Desserts App

## Overview

### Behavior

This app is composed of 2 screens: the meal list and meal details. On the meal list screen, a
request is made to fetch all desserts, which are then sorted based on the title and displayed
in a list, along with a preview image of the dessert. In the event that the request fails, an
alert is displayed which explains the error. Since this request may fail, another attempt to fetch
the meals can be made by tapping on the circular arrow in the top left corner.

A given meal can be tapped from the meal list screen, which will lead to the detail screen for
that particular meal. From here, a request is made to fetch the details for that meal. After the
request completes, either the details are shown or an error message is displayed depending on
whether the detailed were successfully fetched. The detail view is composed of a full-size image of
the meal, a list of ingredients, and the instructions for preparing the dish.

### Architecture

This app was built using the MVVM architecture. Each of the two main views, `ContentView` and
`MealDetailsView`, are served by a view model (`MealListViewModel` and `MealDetailsViewModel`
, respectively). Then, each of the view models are given a `Provider` object which fetches the
required data from some data source. I opted to use protocols (`MealListProviding` and
`MealDetailsProviding`) for the providers so that the real app can use one provider which makes a
network request, while the previews and tests use another provider which loads a local JSON file.

## Meal List Screen

The `ContentView` is initialized with the two providers that are used in the app, an instance of
`MealListProviding` and `MealDetailsProviding`. Then, the `MealListViewModel` state object is
initialized with the `mealListProvider`. Before the view appears, a `task` is run to instruct the
view model to fetch the meals. Since the view model publishes an `isLoading` property, a progress
view will be visible while fetching the data.

Assuming the request is successful, the meal names are all capitalized to provide a consistent
appearance and ensure that the string comparisons to be performed during sorting order items
properly. For instance, "Christmas cake" should be before "Christmas Pudding", but without doing a
case-insensitive comparison or capitalizing each word, the letter 'P' is considered to be less than
'c'. After this transformation, the meals are sorted and then the UI is updated to display a
list of `MealSummaryViews`. The summary views are composed of an `AsyncImage` and the meal name.
Based on the API description, small preview images can be accessed by appending `/preview` to the
value from the `strMealThumb` field. I did notice that the preview images for "Madeira Cake" and
"Pouding Chomeur" don't exist - however, for the sake of efficiency, I decided to continue fetching
the preview images instead of the full-size images. An SF Symbols image is used as a placeholder
for those meals where the preview image can't be accessed.

If there is an error in fetching the meals, the list of meals remains empty and an alert is
displayed which describes the issue. Once the alert is dismissed, an attempt can be made to
reload the meals by tapping on the icon on the left side of the navigation bar. Note that this icon
is disabled while the view model is already fetching meals to avoid concurrent requests.

## Meal Detail Screen

Once the user taps on a `MealSummaryView`, the `MealDetailsView` is initialized with the
`mealDetailsProvider` (passed into `ContentView`) along with the appropriate `MealSummary`. The
summary's `name` property is stored to be used as the view's title, and a `MealDetailsViewModel`
is initialized with the provider and meal ID.

Initially, a `task` in the view tells the view model to fetch the meal details. Similarly to the
previous screen, the view model's `isLoading` property is set to true, which results in a progress
view on the UI. Once the request completes, either an error message or the detail view will replace
the progress view, depending on whether `details` is `nil` or not. For simplicity, I did not make
this screen refreshable; to reload, navigate back to the meal list screen and tap on the meal again.

The detail view is composed of 3 main items: the meal's image, ingredients, and instructions. In
the event that fetching the image fails, I set the placeholder of the `AsyncImage` as a clear view
with a height of 1, essentially being an empty view. While this causes the contents below the
image to jump down when the image *does* come back, I decided that was preferable to showing a
blank box at the top of the screen if fetching the image fails. I didn't observe any of the images
failing to load, but I wanted to add this logic to address what I would consider a realistic
production scenario.

The list of ingredients is handled in the decoder initializer for the `MealDetails` model. There
is logic in place to filter out null and empty values and remove duplicate ingredients. As for the
display of the ingredients, I debated between two approaches:

- Approach 1: `Measurement ingredient` (2 eggs)
- Approach 2: `Ingredient: measurement` (Eggs: 2)

Given the wide range of measurements I encountered, some numeric and some not, I opted to follow
Approach 2. This does result in some odd representations, such as "Ice Cream: to serve",
"Icing Sugar: dusting", and "Oil: for frying". However, I felt that was more reasonable than the
reverse case: "To serve ice cream", "Dusting icing sugar", and "For frying oil". This way, there is
uniform appearance on each meal where the ingredient is before the colon, and the measurement is
after.
 
Additionally, I saw that the measurements and ingredients returned from the API are not uniform in
appearance across the different meals - some words are capitalized while others are not. To
maintain a consistent experience in the list of ingredients for each meal, I decided to capitalize
each word of the ingredient and lowercase the entire measurement.

---

I have included some representative screenshots in the Screenshots folder. Additionally, I added
unit tests for each of the view models. Most of the tests are for handling the different scenarios I
identified when parsing the ingredients.
