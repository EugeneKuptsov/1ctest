#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Вид.СписокВыбора.Добавить("Перечисление.УКО_ВидГраницы.Включая", НСтр("ru = 'Включая'; en = 'Including'"));
	Элементы.Вид.СписокВыбора.Добавить("Перечисление.УКО_ВидГраницы.Исключая", НСтр("ru = 'Исключая'; en = 'Excluding'"));
	
	ОписаниеЗначенияГраница = Параметры.Значение;
	
	Вид = ОписаниеЗначенияГраница.Вид;
	Значение = ОписаниеЗначенияГраница.Значение;
	Элементы.Значение.ВыбиратьТип = (Значение = Неопределено ИЛИ Значение = Дата(1,1,1));
	
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, СтрШаблон(НСтр("ru = 'Редактирование границы %1'; en = 'Editing the border %1'"), Параметры.Заголовок));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Закрыть(УКО_ЗапросКлиентСервер_ОписаниеГраницы(Значение, Вид));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборТипаЗавершен(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Модифицированность = Истина;
	
	ТекущийЭлемент.ОграничениеТипа = Результат;
	ТекущийЭлемент.ВыбиратьТип = Ложь;
	
	Значение = Результат.ПривестиЗначение(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элемент.ВыбиратьТип Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ВыборТипаЗавершен", ЭтотОбъект, Новый Структура);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Заголовок", НСтр("ru = 'Значение'; en = 'Value'"));
		ДополнительныеПараметры.Вставить("ИсключаемыеТипы", "Граница");
		УКО_ФормыКлиент_ОткрытьРедактированиеТипаЗначения(Элемент, "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа",
															Новый ОписаниеТипов("Дата"), ОписаниеОповещенияЗавершение, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("МоментВремени") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("РедактированиеЗначенияЗавершено", ЭтотОбъект);
		УКО_ФормыКлиент_ОткрытьРедактированиеМоментаВремени(НСтр("ru = 'Значение'; en = 'Value'"), Значение, ЭтаФорма, ОписаниеОповещенияЗавершение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	ТекущийЭлемент.ОграничениеТипа = ОписаниеТипов;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеЗначенияЗавершено(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Модифицированность = Истина;
	Значение = Результат;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаКлиенте
// Открывает дополнительную/вспомогательную форму
//
// Параметры:
//	Имя - Строка - Имя формы
//	Параметры - Структура - Параметры формы (необязательный)
//	Владелец - Форма - Форма владелец
//	Уникальность - Произвольный - Уникальность (необязательный)
//	ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - Описание оповещения о закрытии (необязательный)
//
Процедура УКО_ФормыКлиент_ОткрытьДополнительную(Имя, Параметры = Неопределено, Владелец = Неопределено, Уникальность = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	Если УКО_ОбщегоНазначенияКлиентСервер_РежимЗапускаВнешняяОбработка() Тогда
		ОбъектФорм = СтрШаблон("ВнешняяОбработка.%1%2.Форма.", УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения(), УКО_ОбщегоНазначенияКлиентСервер_ИдентификаторРасширения());
	Иначе
		ОбъектФорм = "ОбщаяФорма";
	КонецЕсли;
	
	ПолноеИмяФормы = СтрШаблон("%1.%2%3", ОбъектФорм, УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения(), Имя);
	
	Если Владелец = Неопределено Тогда
		РежимОткрытия = Неопределено;
	Иначе 
		РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОткрытьФорму(ПолноеИмяФормы, Параметры, Владелец, Уникальность,,,ОписаниеОповещенияОЗакрытии, РежимОткрытия);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает описание границы
//
// Параметры:
//   Значение - Граница, Дата, МоментВремени - Значение
//   Вид - Перечисление.УКО_ВидГраницы - Вид границы (по умолчанию: Включая)
//
// Возвращаемое значение:
//   Структура	- Описание границы
//
Функция УКО_ЗапросКлиентСервер_ОписаниеГраницы(Значение, Вид = Неопределено) Экспорт
	
	Результат = Новый Структура;
	
	Если Вид = Неопределено Тогда
		Вид = "Перечисление.УКО_ВидГраницы.Включая";
	КонецЕсли;
	
	Возврат Новый Структура("Вид, Значение", Вид, Значение);
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Определяет, это режим запуска программы
//
// Возвращаемое значение:
//   Булево	- Истина, Режим запуска внешняя обработка
//
Функция УКО_ОбщегоНазначенияКлиентСервер_РежимЗапускаВнешняяОбработка() Экспорт
	
	Возврат Истина;
	
КонецФункции
&НаКлиенте
// Открывает форму редактирования типа значения
//
// Параметры:
//	Владелец - Форма/Элемент - Владелец
//	РежимРедактирования - Перечисление.УКО_РежимРедактированияТипаЗначения - Режим редактирования типа значения
//	Значение - Произвольный/ОписаниеТипов - Значение
//	ОписаниеОповещенияЗавершение - ОписаниеОповещения - Описание оповещения при завершении
//	ДополнительныеПараметры - Структура - Дополнительные параметры
//	 *Заголовок - Строка - Заголовок
//	 *ЗакрыватьПриВыборе - Булево - Закрывать при выборе
//	 *ИсключаемыеТипы - Строка - Исключаемые типы через запятую
//
Процедура УКО_ФормыКлиент_ОткрытьРедактированиеТипаЗначения(Владелец, РежимРедактирования, Значение, ОписаниеОповещенияЗавершение, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Значение", Значение);
	ПараметрыФормы.Вставить("Режим", РежимРедактирования);
	
	ПараметрыФормы.Вставить("Заголовок", УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(ДополнительныеПараметры, "Заголовок", ""));
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(ДополнительныеПараметры, "ЗакрыватьПриВыборе", Истина));
	ПараметрыФормы.Вставить("ИсключаемыеТипы", УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(ДополнительныеПараметры, "ИсключаемыеТипы", ""));
	
	ВыборТипа = (РежимРедактирования = "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа");
	ОписаниеОповещенияЗавершение.ДополнительныеПараметры.Вставить("ВыборТипа", ВыборТипа);
	
	УКО_ФормыКлиент_ОткрытьДополнительную("РедактированиеТипаЗначения", ПараметрыФормы, Владелец,, ОписаниеОповещенияЗавершение);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает идентификатор расширения
// Возвращаемое значение:
//   Строка	- Идентификатор расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИдентификаторРасширения() Экспорт 
	
	Возврат "УправляемаяКонсольОтчетов";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Обновляет заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Булево - Дополнять заголовок названием расширения
//
Процедура УКО_ФормыКлиентСервер_Заголовок(Форма, Заголовок, Дополнение = Ложь) Экспорт
	
	НовыйЗаголовок = Заголовок;
	
	Если Дополнение Тогда
		НовыйЗаголовок = НовыйЗаголовок + " : " + УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения();
	КонецЕсли;
	
	Форма.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Получает значение свойства структуры
// Параметры:
//   Структура - Структура - Структура
//   Имя - Строка - Имя свойства
//   ЗначениеПоУмолчанию - Произвольный - Значение по умолчанию, когда в данной структуре нет этого свойства
// Возвращаемое значение:
//   Произвольный - Значение свойства структуры
Функция УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(Структура = Неопределено, Имя = Неопределено, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Значение = ЗначениеПоУмолчанию;
	
	Если (ТипЗнч(Структура) = Тип("Структура")
				ИЛИ ТипЗнч(Структура) = Тип("ДанныеФормыСтруктура"))
			И Структура.Свойство(Имя) Тогда
		
		Значение = Структура[Имя];
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает префикс объектов расширения
// Возвращаемое значение:
//   Строка	- Префикс объектов расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения() Экспорт 
	
	Возврат "УКО_";
	
КонецФункции
&НаКлиенте
// Открывает форму редактирования Момента времени
//
// Параметры:
//	Заголовок - Строка - Заголовок
//	Значение - МоментВремени - Значение
//	ФормаВладелец - Форма - Форма владелец
//	ОписаниеОповещенияЗавершение - ОписаниеОповещения - Описание оповещения при завершении
//
Процедура УКО_ФормыКлиент_ОткрытьРедактированиеМоментаВремени(Заголовок, Значение, ФормаВладелец, ОписаниеОповещенияЗавершение) Экспорт
	
	ПараметрыФормы = Новый Структура("Заголовок, Значение", Заголовок, Значение);
	УКО_ФормыКлиент_ОткрытьДополнительную("РедактированиеМоментаВремени", ПараметрыФормы, ФормаВладелец,, ОписаниеОповещенияЗавершение);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
