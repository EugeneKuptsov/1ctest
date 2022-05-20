#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, НСтр("ru = 'Экспорт в'; en = 'Export to'"));
	ОбъектОбработки().УКО_ПроверкаОшибокВФорме_Инициализировать(ЭтаФорма);
	
	Имя = ИмяФайлаВыводаРезультата();
	
	СписокФорматов = Новый СписокЗначений;
	СписокФорматов.Добавить("XLSX", "Excel 2007",, Элементы.БиблиотекаКартинокУКО_Excel.Картинка);
	СписокФорматов.Добавить("MXL", "MXL");
	СписокФорматов.Добавить("PDF", "PDF");
	
	Если Не ЗначениеЗаполнено(Формат) Тогда
		Формат = "XLSX";
	КонецЕсли;
	
	Для Каждого ЭлементФормат Из СписокФорматов Цикл 
		
		ИмяКоманды = ЭлементФормат.Значение;
		
		НоваяКоманда = Команды.Добавить(ИмяКоманды);
		НоваяКоманда.Заголовок = ЭлементФормат.Представление;
		НоваяКоманда.Картинка = ЭлементФормат.Картинка;
		НоваяКоманда.Действие = "КомандаФормат";
		
		НовыйЭлемент = Элементы.Добавить("Кнопка" + ИмяКоманды, Тип("КнопкаФормы"), Элементы.Формат);
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
		НовыйЭлемент.Отображение = ОтображениеКнопки.КартинкаИТекст;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Каталог = Каталог;
	
	ДиалогВыбораКаталога.Показать(Новый ОписаниеОповещения("ЗавершенВыборКаталога", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УКО_ПроверкаОшибокВФормеКлиент_ОбработкаНавигационнойСсылки(ЭтаФорма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаФормат(Команда)
	
	Формат = Команда.Имя;
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортВ(Команда)
	
	ОшибкиЗаполнения = ПроверкаЗаполнения();
	Если ЗначениеЗаполнено(ОшибкиЗаполнения) Тогда
		
		УКО_ПроверкаОшибокВФормеКлиент_ТекущийЭлементПоПервой(ЭтаФорма, ОшибкиЗаполнения);
		
	Иначе
		
		Результат = Новый Структура;
		Результат.Вставить("ПолноеИмяФайла", СтрШаблон("%1\%2.%3", Каталог, Имя, РасширениеПоТипу(Формат)));
		Результат.Вставить("Формат", Формат);
		Результат.Вставить("ОткрытьПослеСохранения", ОткрытьПослеСохранения);
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция РасширениеПоТипу(ИмяФормата)
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("XLS", "xls");
	Соответствие.Вставить("XLSX", "xlsx");
	Соответствие.Вставить("MXL", "mxl");
	Соответствие.Вставить("PDF", "pdf");
	Соответствие.Вставить("DOCX", "docx");
	Соответствие.Вставить("HTML5", "html");
	Соответствие.Вставить("ODS", "ods");
	
	Возврат Соответствие.Получить(ИмяФормата);
	
КонецФункции

&НаКлиенте
Процедура ЗавершенВыборКаталога(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Каталог = Результат[0];
	КаталогПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлементыФормы()
	
	Для Каждого КнопкаФормат Из Элементы.Формат.ПодчиненныеЭлементы Цикл 
		КнопкаФормат.Пометка = (Формат = КнопкаФормат.ИмяКоманды);
	КонецЦикла;
	
	Расширение = "." + РасширениеПоТипу(Формат);
	
	УКО_ПроверкаОшибокВФормеКлиент_Обновить(ЭтаФорма, ПроверкаЗаполнения());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДанныхПослеОжидания()

	ОбновитьЭлементыФормы();

КонецПроцедуры

&НаКлиенте
Функция ПроверкаЗаполнения()
	
	Результат = Новый СписокЗначений;
	
	Если Не ЗначениеЗаполнено(Имя) Тогда
		Результат.Добавить("Имя", НСтр("ru = 'Не заполнено имя'; en = 'Name is not filled'"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Каталог) Тогда
		Результат.Добавить("Каталог", НСтр("ru = 'Не указан каталог'; en = 'Directory not specified'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не ЗначениеЗаполнено(Настройки["Формат"]) Тогда
		Настройки.Вставить("Формат", "XLSX");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Настройки["Имя"]) Тогда
		Настройки.Вставить("Имя", ИмяФайлаВыводаРезультата());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяФайлаВыводаРезультата()
	
	Возврат НСтр("ru = 'Результат'; en = 'Result'");
	
КонецФункции

#КонецОбласти


&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
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
// Обновляет данные элементов ошибок
//
// Параметры:
//  Форма - Форма - Форма
//  Ошибки - СписокЗначение - Ошибки Значение - имя элемента, Представление - Текст ошибки
//
Процедура УКО_ПроверкаОшибокВФормеКлиент_Обновить(Форма, Ошибки) Экспорт
	
	Результат = Новый Массив;
	КоличествоСтрок = 0;
	Для Каждого Ошибка Из Ошибки Цикл 
		
		Если ЗначениеЗаполнено(Результат) Тогда
			Результат.Добавить(Символы.ПС);
		КонецЕсли;
		
		ТекстОшибки = Ошибка.Представление;
		КоличествоСтрок = КоличествоСтрок + СтрЧислоСтрок(ТекстОшибки);
		Результат.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаВажнойГиперссылки(),, Ошибка.Значение));
		
	КонецЦикла;
	
	ЭлементОшибки = Форма.Элементы.Ошибки;
	КоличествоОшибок = Ошибки.Количество();
	
	Если ЭлементОшибки.Высота < КоличествоСтрок Тогда
		ЭлементОшибки.Высота = КоличествоСтрок;
	КонецЕсли;

	Форма.Ошибки = Новый ФорматированнаяСтрока(Результат);
	
КонецПроцедуры
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
&НаКлиенте
// Обработчик события ОбработкаНавигационнойСсылки
//
// Параметры:
//  Форма - Форма - Форма
//  Элемент - Элемент - Элемент
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - Текст навигационной ссылки
//  СтандартнаяОбработка - Булево - Признак стандартной обработки
//
Процедура УКО_ПроверкаОшибокВФормеКлиент_ОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Форма.ТекущийЭлемент = Форма.Элементы[НавигационнаяСсылкаФорматированнойСтроки];
	
КонецПроцедуры
&НаКлиенте
// Устанавливает текущим первый элемент ошибки
//
// Параметры:
//  Форма - Форма - Форма
//  Ошибки - СписокЗначение - Ошибки Значение - имя элемента, Представление - Текст ошибки
//
Процедура УКО_ПроверкаОшибокВФормеКлиент_ТекущийЭлементПоПервой(Форма, Ошибки) Экспорт
	
	Форма.ТекущийЭлемент = Форма.Элементы[Ошибки[0].Значение];
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
