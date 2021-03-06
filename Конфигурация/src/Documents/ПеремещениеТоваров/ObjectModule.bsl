
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ТоварыНаСкладах Расход
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Склад = СкладОтправитель;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;

	// регистр ТоварыНаСкладах Приход
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Склад = СкладОтправитель;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;

КонецПроцедуры
