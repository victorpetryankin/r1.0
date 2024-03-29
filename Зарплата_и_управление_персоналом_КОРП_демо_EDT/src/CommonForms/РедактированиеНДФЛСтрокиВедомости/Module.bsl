#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИдентификаторСтроки",	ИдентификаторСтроки);
	НДФЛ.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилищеНДФЛПоСтроке));
	
	Параметры.Свойство("ФизическоеЛицо",		ФизическоеЛицо);
	
	Параметры.Свойство("Организация",			Организация);
	Параметры.Свойство("Подразделение",			Подразделение);
	Параметры.Свойство("ПериодРегистрации",		ПериодРегистрации);
	
	Параметры.Свойство("ДатаВыплаты", ДатаВыплаты);
	КатегорииСФиксированнойДатой = Новый ФиксированныйМассив(Перечисления.КатегорииДоходовНДФЛ.СФиксированнойДатойПолученияДохода());
	Для Каждого СтрокаНДФЛ Из НДФЛ Цикл
		Если КатегорииСФиксированнойДатой.Найти(СтрокаНДФЛ.КатегорияДохода) = Неопределено Тогда
			СтрокаНДФЛ.БеретсяИзДатыВыплаты = Истина;
			СтрокаНДФЛ.ДатаПолученияДохода = ДатаВыплаты;
		Иначе
			СтрокаНДФЛ.БеретсяИзДатыВыплаты = Ложь;
			СтрокаНДФЛ.ДатаПолученияДохода = СтрокаНДФЛ.МесяцНалоговогоПериода;
		КонецЕсли;
	КонецЦикла;
	
	Заголовок = Строка(ФизическоеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура НДФЛПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, ЭтаФорма);
		Элемент.ТекущиеДанные.МесяцНалоговогоПериода = ДатаВыплаты;
		Элемент.ТекущиеДанные.ДатаПолученияДохода = ДатаВыплаты;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура НДФЛКатегорияДоходаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.НДФЛ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БеретсяИзДатыВыплаты = КатегорииСФиксированнойДатой.Найти(ТекущиеДанные.КатегорияДохода) = Неопределено;
	ПерезаполнитьДаты = ТекущиеДанные.БеретсяИзДатыВыплаты <> БеретсяИзДатыВыплаты;
	ТекущиеДанные.БеретсяИзДатыВыплаты = БеретсяИзДатыВыплаты;
	Если ПерезаполнитьДаты Тогда
		Если БеретсяИзДатыВыплаты Тогда
			ТекущиеДанные.ДатаПолученияДохода = ДатаВыплаты;
		Иначе
			ТекущиеДанные.ДатаПолученияДохода = ТекущиеДанные.МесяцНалоговогоПериода;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатыРедактирования = Новый Структура;
		РезультатыРедактирования.Вставить("Модифицированность", Модифицированность);
		РезультатыРедактирования.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
		РезультатыРедактирования.Вставить("АдресВХранилищеНДФЛПоСтроке", АдресВХранилищеНДФЛПоСтроке());
		
		Модифицированность = Ложь;
		Закрыть(РезультатыРедактирования)
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке()
	
	НДФЛФизлица = НДФЛ.Выгрузить();
	Для Каждого СтрокаНДФЛ Из НДФЛФизлица Цикл
		СтрокаНДФЛ.ИдентификаторСтроки = ИдентификаторСтроки;
		Если Не СтрокаНДФЛ.БеретсяИзДатыВыплаты Тогда
			 СтрокаНДФЛ.МесяцНалоговогоПериода = СтрокаНДФЛ.ДатаПолученияДохода;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(НДФЛФизлица, УникальныйИдентификатор);
	
КонецФункции	

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НДФЛДатаПолученияДохода.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НДФЛ.БеретсяИзДатыВыплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
КонецПроцедуры

#КонецОбласти
