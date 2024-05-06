enum CategoryEnum {
  appetizers("Закуски"),
  mainCourses('Горячее'),
  soups('Супы'),
  pastas('Паста ручной работы'),
  sets('Сеты на компанию'),
  salads('Салаты'),
  hotDrinks('Горячие напитки'),
  coldDrinks('Прохладительные  напитки'),
  sideDishes('Гарниры'),
  pizzas('Пицца');

  final String name;
  const CategoryEnum(this.name);
}
