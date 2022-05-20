﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, СтрШаблон(НСтр("ru = 'История версий (ваша версия %1)'; en = 'Version history (your version %1)'"), УКО_ОбщегоНазначенияКлиентСервер_ВерсияРасширения()));
	
	ПроверкаОбновления = Параметры.ПроверкаОбновления;
	
	Макет = ОбъектОбработки().ПолучитьМакет("УКО_ИсторияВерсий");
	
	ИсторияВерсий.НачатьАвтогруппировкуСтрок();
	Для НомерСтроки = 1 По Макет.ВысотаТаблицы Цикл 
		
		Область = Макет.Область(НомерСтроки,1);
		ОбластьВывода = Макет.ПолучитьОбласть(НомерСтроки,1);
		
		Если Область.Отступ > 0 Тогда
			Уровень = 2;
		Иначе
			Уровень = 1;
		КонецЕсли;
		
		ИсторияВерсий.Вывести(ОбластьВывода, Уровень);

	КонецЦикла;
	
	ИсторияВерсий.ЗакончитьАвтогруппировкуСтрок();
	
	ОбъектОбработки().УКО_ПроверкаОбновлений_Инициализировать(ЭтаФорма, Элементы.ФормаГруппаДоступноОбновление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УКО_ПроверкаОбновленийКлиент_Инициализация(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверкаОбновления(Команда)
	
	УКО_ПроверкаОбновленийКлиент_ОбработкаДоступноОбновление(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти


&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает версию расширения
// Возвращаемое значение:
//   Строка	- версию расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ВерсияРасширения() Экспорт
	
	Возврат "3.8.9";
	
КонецФункции
&НаКлиенте
// Инициализация формы для проверки обновлений
//
// Параметры:
//  Форма  - Форма - Форма
//
Процедура УКО_ПроверкаОбновленийКлиент_Инициализация(Форма) Экспорт
	
	ПроверкаОбновления = Форма["ПроверкаОбновления"];
	
	АктуальнаяВерсия = ПроверкаОбновления.АктуальнаяВерсия;
	ДатаПроверкиОбновления = ПроверкаОбновления.ДатаПроверкиОбновления;
	
	Если Не ЗначениеЗаполнено(ДатаПроверкиОбновления)
			ИЛИ (ТекущаяДата() - ДатаПроверкиОбновления) > 24*60*60 Тогда
			
		АктуальнаяВерсия = УКО_ПроверкаОбновленийКлиент_ПроверитьАктуальнуюВерсию();
		ПроверкаОбновления.АктуальнаяВерсия = АктуальнаяВерсия;
		ПроверкаОбновления.ДатаПроверкиОбновления = ТекущаяДата();
		
	КонецЕсли;
	
	ЭлементДоступноОбновление = Форма.Элементы["ПроверкаОбновления"];
	ВерсияРасширения = УКО_ОбщегоНазначенияКлиентСервер_ВерсияРасширения();
	ЭлементДоступноОбновление.Видимость = ЗначениеЗаполнено(АктуальнаяВерсия) 
													И ВерсияРасширения < АктуальнаяВерсия;

	Если ЗначениеЗаполнено(АктуальнаяВерсия) 
			И УКО_ПроверкаОбновленийКлиент_РедакцияВерсии(ВерсияРасширения) <> УКО_ПроверкаОбновленийКлиент_РедакцияВерсии(АктуальнаяВерсия) Тогда
		ЦветТекста = УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаВажнойГиперссылки();
	Иначе
		ЦветТекста = УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаГиперссылки();
	КонецЕсли;
	
	ЭлементДоступноОбновление.ЦветТекста = ЦветТекста;
	
КонецПроцедуры
&НаКлиенте

Функция УКО_ПроверкаОбновленийКлиент_ПроверитьАктуальнуюВерсию()
	
	Возврат УКО_ПроверкаОбновленийКлиент_HttpЗапросКСерверу("/version.txt");
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает цвет текста гиперссылки
//
// Возвращаемое значение:
//   Цвет - Цвет текста
//
Функция УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаГиперссылки() Экспорт
	
	// https://ru.wikipedia.org/wiki/%D0%92%D0%B8%D0%BA%D0%B8%D0%BF%D0%B5%D0%B4%D0%B8%D1%8F:%D0%A6%D0%B2%D0%B5%D1%82%D0%B0_%D1%81%D1%81%D1%8B%D0%BB%D0%BE%D0%BA
	// Голубая ссылка
	Возврат Новый Цвет(51,102,187); 
	
КонецФункции
&НаКлиенте

Функция УКО_ПроверкаОбновленийКлиент_РедакцияВерсии(Версия)
	
	Если Не ЗначениеЗаполнено(Версия) Тогда
		
		Результат = Неопределено;
		
	Иначе
		
		ВерсияДетально = СтрРазделить(Версия, ".");
		Результат = ВерсияДетально[1];
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает цвет текста важной гиперссылки
//
// Возвращаемое значение:
//   Цвет - Цвет текста
//
Функция УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаВажнойГиперссылки() Экспорт
	
	Возврат Новый Цвет(125,0,0); 
	
КонецФункции
&НаКлиенте

Функция УКО_ПроверкаОбновленийКлиент_HttpЗапросКСерверу(Запрос)
	
	// Тест обновления
	//Путь = "G:\УКО\update";
	//ПолныйПуть = СтрЗаменить(Путь + Запрос, "/", "\");
	//ТекстовыйДокумент = Новый ТекстовыйДокумент;
	//ТекстовыйДокумент.Прочитать(ПолныйПуть);
	//Возврат ТекстовыйДокумент.ПолучитьТекст();
	
	Результат = Неопределено;
	
	Попытка
		
		HTTPСоединение = Новый HTTPСоединение(УКО_ПроверкаОбновленийКлиент_АдресСервера(),,,,,1);
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("User-Agent", "Mozilla/5.0");
		
		HTTPЗапрос = Новый HTTPЗапрос(Запрос, Заголовки);  
		Ответ = HTTPСоединение.Получить(HTTPЗапрос);    
		
		Если Ответ.КодСостояния < 300 Тогда
			Результат = Ответ.ПолучитьТелоКакСтроку();
		КонецЕсли;

	Исключение
		
		НеОбрабатываемИсключение = Истина;
		
	КонецПопытки;
	
	Возврат Результат;
	
	
КонецФункции
&НаКлиенте

Функция УКО_ПроверкаОбновленийКлиент_АдресСервера()
	
	Возврат "q92801lf.beget.tech";
	
КонецФункции
&НаКлиенте
// Обработки команды доступно обновление
//
// Параметры:
//  Форма  - Форма - Форма
//
Процедура УКО_ПроверкаОбновленийКлиент_ОбработкаДоступноОбновление(Форма) Экспорт
	
	УКО_ФормыКлиент_ОткрытьДополнительную("ДоступноОбновление",, Форма);

КонецПроцедуры
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
// Возвращает идентификатор расширения
// Возвращаемое значение:
//   Строка	- Идентификатор расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИдентификаторРасширения() Экспорт 
	
	Возврат "УправляемаяКонсольОтчетов";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает префикс объектов расширения
// Возвращаемое значение:
//   Строка	- Префикс объектов расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения() Экспорт 
	
	Возврат "УКО_";
	
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
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
