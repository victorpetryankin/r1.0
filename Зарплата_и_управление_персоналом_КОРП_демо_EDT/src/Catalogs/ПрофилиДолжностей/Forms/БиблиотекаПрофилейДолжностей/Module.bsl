
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуПрофилей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрофилиДолжностей

&НаКлиенте
Процедура ПрофилиДолжностейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеПрофилей(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыборВСпискеПрофилей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуПрофилей()
	
	БиблиотекаXML = Справочники.ПрофилиДолжностей.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаXML).Данные;
	
	Для Каждого ТекущаяСтрока Из БиблиотекаТаблица Цикл
		НоваяСтрока = ХарактеристикиПрофилей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
	БиблиотекаТаблица.Свернуть("Наименование, Требования, Обязанности, Условия, Подразделение, Должность");
	Для Каждого ТекущаяСтрока Из БиблиотекаТаблица Цикл
		НоваяСтрока = ПрофилиДолжностей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
	БиблиотекаДействийXML = Справочники.ПрофилиДолжностей.ПолучитьМакет("БиблиотекаДействий").ПолучитьТекст();
	БиблиотекаДействийТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаДействийXML).Данные;
	Для Каждого ТекущаяСтрока Из БиблиотекаДействийТаблица Цикл
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ДействиеСотрудника) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ДействияСотрудников.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
	БиблиотекаЭтаповXML = Справочники.ПрофилиДолжностей.ПолучитьМакет("БиблиотекаЭтапов").ПолучитьТекст();
	БиблиотекаЭтаповТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаЭтаповXML).Данные;
	
	ТаблицаЭтапов = БиблиотекаЭтаповТаблица.Скопировать();
	ТаблицаЭтапов.Свернуть("Наименование, ЭтапРаботы, Комментарий");
	Для Каждого ТекущаяСтрока Из ТаблицаЭтапов Цикл
		НоваяСтрока = ЭтапыРаботы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
	ТаблицаВопросов = БиблиотекаЭтаповТаблица.Скопировать();
	ТаблицаВопросов.Свернуть("Наименование, ЭтапРаботы, ВопросШаблонаАнкеты, Родитель, ЭтоГруппа, Формулировка, ТипВопроса, ТипТабличногоВопроса, 
								|ЭлементарныйВопрос, Подсказка, СпособОтображенияПодсказки, ВопросДляСобеседования");
	Для Каждого ТекущаяСтрока Из ТаблицаВопросов Цикл
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ВопросШаблонаАнкеты) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ВопросыЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
	СоставКомплексногоВопроса = БиблиотекаЭтаповТаблица.Скопировать();
	СоставКомплексногоВопроса.Свернуть("Наименование, ЭтапРаботы, ВопросШаблонаАнкеты, ЭлементарныйВопросКомплексногоВопроса");
	Для Каждого ТекущаяСтрока Из СоставКомплексногоВопроса Цикл
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЭлементарныйВопросКомплексногоВопроса) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = КомплексныеВопросы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		НоваяСтрока.ЭлементарныйВопрос = ТекущаяСтрока.ЭлементарныйВопросКомплексногоВопроса;
	КонецЦикла;
	
	ТаблицаНастроек = БиблиотекаЭтаповТаблица.Скопировать();
	ТаблицаНастроек.Свернуть("Наименование, ВопросДляСобеседования, ЭлементарныйВопросИзНастройки, ОтветНаВопросИзНастройки, 
											|ХарактеристикаПерсоналаИзНастройки, ЗначениеХарактеристикиИзНастройки, Балл");
	Для Каждого ТекущаяСтрока Из ТаблицаНастроек Цикл
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ВопросДляСобеседования) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = НастройкиЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		НоваяСтрока.ЭлементарныйВопрос = ТекущаяСтрока.ЭлементарныйВопросИзНастройки;
		НоваяСтрока.ОтветНаВопрос = ТекущаяСтрока.ОтветНаВопросИзНастройки;
		НоваяСтрока.ХарактеристикаПерсонала = ТекущаяСтрока.ХарактеристикаПерсоналаИзНастройки;
		НоваяСтрока.ЗначениеХарактеристики = ТекущаяСтрока.ЗначениеХарактеристикиИзНастройки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки, ТекущаяСсылка)
	
	БиблиотекаВопросовXML = Справочники.ВопросыДляСобеседования.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаВопросовТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаВопросовXML).Данные;
	БиблиотекаВопросовТаблицаКлючевыхВопросов = БиблиотекаВопросовТаблица.Скопировать();
	БиблиотекаВопросовТаблицаКлючевыхВопросов.Свернуть("Наименование, ЭлементарныйВопрос, Предопределенный, ТребуетсяКомментарий, ПояснениеКомментария");
	БиблиотекаВопросовОтветовXML = Справочники.ВопросыДляСобеседования.ПолучитьМакет("БиблиотекаОтветов").ПолучитьТекст();
	БиблиотекаВопросовОтветовТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаВопросовОтветовXML).Данные;
	
	БиблиотекаХарактеристикXML = ПланыВидовХарактеристик.ХарактеристикиПерсонала.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаХарактеристикТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаХарактеристикXML).Данные;
	
	БиблиотекаДействийXML = Справочники.ДействияСотрудников.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаДействийТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаДействийXML).Данные;
	
	БиблиотекаЭлементарныхОтветовXML = Справочники.ПрофилиДолжностей.ПолучитьМакет("БиблиотекаОтветов").ПолучитьТекст();
	БиблиотекаЭлементарныхОтветовТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаЭлементарныхОтветовXML).Данные;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = ПрофилиДолжностей[НомерСтроки];
		
		СтрокаВБазе = Справочники.ПрофилиДолжностей.НайтиПоНаименованию(ТекущиеДанные.Наименование, Истина);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.ПрофилиДолжностей.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Должность = Справочники.Должности.НайтиПоНаименованию(ТекущиеДанные.Должность, Истина);
		Если Не ЗначениеЗаполнено(Должность) Тогда
			УстановитьПривилегированныйРежим(Истина);
			НоваяДолжность = Справочники.Должности.СоздатьЭлемент();
			НоваяДолжность.Наименование = ТекущиеДанные.Должность;
			НоваяДолжность.Записать();
			УстановитьПривилегированныйРежим(Ложь);
			Должность = НоваяДолжность.Ссылка;
		КонецЕсли;
		
		НоваяСтрока = Справочники.ПрофилиДолжностей.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		НоваяСтрока.Должность = Должность;
		НоваяСтрока.Подразделение = Справочники.СтруктураПредприятия.НайтиПоНаименованию(ТекущиеДанные.Подразделение, Истина);
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
		СтрокиЗначений = ХарактеристикиПрофилей.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.Характеристика) Тогда
				Продолжить;
			КонецЕсли;
			СтруктураХарактеристики = ХарактеристикиПерсонала.ХарактеристикаИзМакета(ТекущаяСтрока.Характеристика, ТекущаяСтрока.Значение, БиблиотекаХарактеристикТаблица);
			Если СтруктураХарактеристики = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрокаТЧ = НоваяСтрока.ХарактеристикиПерсонала.Добавить();
			НоваяСтрокаТЧ.Характеристика = СтруктураХарактеристики.Характеристика;
			НоваяСтрокаТЧ.Значение = СтруктураХарактеристики.Значение;
			НоваяСтрокаТЧ.Вес = ТекущаяСтрока.Вес;
			НоваяСтрокаТЧ.ВесЗначения = ТекущаяСтрока.ВесЗначения;
			НоваяСтрокаТЧ.ТребуетсяОбучение = ТекущаяСтрока.ТребуетсяОбучение;
			НоваяСтрокаТЧ.ТребуетсяПроверка = ТекущаяСтрока.ТребуетсяПроверка;
		КонецЦикла;
		
		СтрокиДействий = ДействияСотрудников.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиДействий Цикл
			ДействиеСотрудника = ХарактеристикиПерсонала.ДействиеСотрудникаИзМакета(ТекущаяСтрока.ДействиеСотрудника, БиблиотекаДействийТаблица, БиблиотекаХарактеристикТаблица);
			Если Не ЗначениеЗаполнено(ДействиеСотрудника) Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрокаТЧ = НоваяСтрока.ДействияСотрудников.Добавить();
			НоваяСтрокаТЧ.ДействиеСотрудника = ДействиеСотрудника;
		КонецЦикла;
		
		НастройкиВопросовДляСобеседования = Новый Соответствие;
		СтрокиЭтапов = ЭтапыРаботы.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЭтапов Цикл
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЭтапРаботы) Тогда
				Продолжить;
			КонецЕсли;
			ЭтапРаботы = Справочники.ЭтапыРаботыСКандидатами.НайтиПоНаименованию(ТекущаяСтрока.ЭтапРаботы, Истина);
			Если Не ЗначениеЗаполнено(ЭтапРаботы) Тогда
				НовыйЭтапРаботы = Справочники.ЭтапыРаботыСКандидатами.СоздатьЭлемент();
				НовыйЭтапРаботы.Наименование = ТекущаяСтрока.ЭтапРаботы;
				НовыйЭтапРаботы.Записать();
				ЭтапРаботы = НовыйЭтапРаботы.Ссылка;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
			СтруктураПоиска.Вставить("ЭтапРаботы", ТекущаяСтрока.ЭтапРаботы);
			СтрокиВопросов = ВопросыЭтапов.НайтиСтроки(СтруктураПоиска);
			ШаблонАнкеты = Справочники.ШаблоныАнкет.ПустаяСсылка();
			Если СтрокиВопросов.Количество() > 0 Тогда
				НовыйШаблонАнкеты = Справочники.ШаблоныАнкет.СоздатьЭлемент();
				НовыйШаблонАнкеты.Наименование = ТекущиеДанные.Наименование + " / " + ТекущаяСтрока.ЭтапРаботы;
				НовыйШаблонАнкеты.Заголовок = НовыйШаблонАнкеты.Наименование;
				НовыйШаблонАнкеты.Вступление = ТекущаяСтрока.ВступлениеАнкеты;
				НовыйШаблонАнкеты.Заключение = ТекущаяСтрока.ЗаключениеАнкеты;
				НовыйШаблонАнкеты.Записать();
				ШаблонАнкеты = НовыйШаблонАнкеты.Ссылка;
			КонецЕсли;
			НоваяСтрокаТЧ = НоваяСтрока.ЭтапыРаботыСКандидатами.Добавить();
			НоваяСтрокаТЧ.ЭтапРаботы = ЭтапРаботы;
			НоваяСтрокаТЧ.Комментарий = ТекущаяСтрока.Комментарий;
			НоваяСтрокаТЧ.ШаблонАнкеты = ШаблонАнкеты;
			
			МассивРазделов = Новый Массив;
			Для Каждого ТекущийВопрос Из СтрокиВопросов Цикл
				Если ТекущийВопрос.ЭтоГруппа Тогда
					НовыйВопросШаблона = Справочники.ВопросыШаблонаАнкеты.СоздатьГруппу();
					НовыйВопросШаблона.Наименование = ТекущийВопрос.ВопросШаблонаАнкеты;
					НовыйВопросШаблона.Формулировка = ТекущийВопрос.Формулировка;
					НовыйВопросШаблона.Владелец     = ШаблонАнкеты;
					НовыйВопросШаблона.Записать();
					МассивРазделов.Добавить(НовыйВопросШаблона.Ссылка);
				Иначе
					ВопросДляСобеседования = ЭлектронноеИнтервью.ВопросДляСобеседованияИзМакета(ТекущийВопрос.ВопросДляСобеседования, БиблиотекаВопросовТаблица, БиблиотекаВопросовТаблицаКлючевыхВопросов, БиблиотекаВопросовОтветовТаблица, БиблиотекаХарактеристикТаблица);
					МассивЭлементарныхВопросов = Новый Массив;
					
					НовыйВопросШаблона = Справочники.ВопросыШаблонаАнкеты.СоздатьЭлемент();
					НовыйВопросШаблона.Владелец = ШаблонАнкеты;
					НовыйВопросШаблона.Наименование = ТекущийВопрос.ВопросШаблонаАнкеты;
					НовыйВопросШаблона.Формулировка = ТекущийВопрос.Формулировка;
					НовыйВопросШаблона.ТипВопроса = Перечисления.ТипыВопросовШаблонаАнкеты[ТекущийВопрос.ТипВопроса];
					Если ЗначениеЗаполнено(ТекущийВопрос.ТипТабличногоВопроса) Тогда
						НовыйВопросШаблона.ТипТабличногоВопроса = Перечисления.ТипыТабличныхВопросов[ТекущийВопрос.ТипТабличногоВопроса];
					КонецЕсли;
					Если ЗначениеЗаполнено(ТекущийВопрос.ЭлементарныйВопрос) Тогда
						СтруктураЭлементарногоВопроса = ЭлементарныйВопрос(ТекущийВопрос.ЭлементарныйВопрос, ТекущиеДанные.Наименование, ТекущаяСтрока.ЭтапРаботы, ТекущийВопрос.ВопросШаблонаАнкеты, БиблиотекаЭлементарныхОтветовТаблица);
						НовыйВопросШаблона.ЭлементарныйВопрос = СтруктураЭлементарногоВопроса.ЭлементарныйВопрос;
						МассивЭлементарныхВопросов.Добавить(СтруктураЭлементарногоВопроса);
					КонецЕсли;
					НовыйВопросШаблона.Подсказка = ТекущийВопрос.Подсказка;
					НовыйВопросШаблона.СпособОтображенияПодсказки = Перечисления.СпособыОтображенияПодсказок[ТекущийВопрос.СпособОтображенияПодсказки];
					Если ЗначениеЗаполнено(ТекущийВопрос.Родитель) Тогда
						Родитель = Справочники.ВопросыШаблонаАнкеты.ПустаяСсылка();
						Для Каждого ТекущийРаздел Из МассивРазделов Цикл
							Если ТекущийРаздел.Наименование = ТекущийВопрос.Родитель Тогда
								Родитель = ТекущийРаздел;
								Прервать;
							КонецЕсли;
						КонецЦикла;
						НовыйВопросШаблона.Родитель = Родитель;
					КонецЕсли;
					
					СтруктураПоиска = Новый Структура;
					СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
					СтруктураПоиска.Вставить("ЭтапРаботы", ТекущаяСтрока.ЭтапРаботы);
					СтруктураПоиска.Вставить("ВопросШаблонаАнкеты", ТекущийВопрос.ВопросШаблонаАнкеты);
					СтрокиТЧСоставКомплексногоВопроса = КомплексныеВопросы.НайтиСтроки(СтруктураПоиска);
					Для Каждого СтрокаКомплексногоВопроса Из СтрокиТЧСоставКомплексногоВопроса Цикл
						НоваяСтрокаТЧВопроса = НовыйВопросШаблона.СоставКомплексногоВопроса.Добавить();
						СтруктураЭлементарногоВопроса = ЭлементарныйВопрос(СтрокаКомплексногоВопроса.ЭлементарныйВопрос, ТекущиеДанные.Наименование, ТекущаяСтрока.ЭтапРаботы, ТекущийВопрос.ВопросШаблонаАнкеты, БиблиотекаЭлементарныхОтветовТаблица);
						НоваяСтрокаТЧВопроса.ЭлементарныйВопрос = СтруктураЭлементарногоВопроса.ЭлементарныйВопрос;
						МассивЭлементарныхВопросов.Добавить(СтруктураЭлементарногоВопроса);
					КонецЦикла;
					
					НовыйВопросШаблона.Записать();
					
					Если ЗначениеЗаполнено(ВопросДляСобеседования) Тогда
						НоваяЗапись = РегистрыСведений.ВопросыДляСобеседованияВопросовШаблоновАнкет.СоздатьМенеджерЗаписи();
						НоваяЗапись.ВопросШаблонаАнкеты = НовыйВопросШаблона.Ссылка;
						НоваяЗапись.ВопросДляСобеседования = ВопросДляСобеседования;
						НоваяЗапись.Записать();
						НастройкиВопросовДляСобеседования.Вставить(ВопросДляСобеседования, МассивЭлементарныхВопросов);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		НоваяСтрока.Записать();
		
		Для Каждого ВопросДляСобеседования Из НастройкиВопросовДляСобеседования Цикл
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
			СтруктураПоиска.Вставить("ВопросДляСобеседования", ВопросДляСобеседования.Ключ.Наименование); 
			СтрокиНастройки = НастройкиЭтапов.НайтиСтроки(СтруктураПоиска);
			Для Каждого ТекущаяНастройка Из СтрокиНастройки Цикл
				НоваяЗапись = РегистрыСведений.НастройкаВопросовДляСобеседования.СоздатьМенеджерЗаписи();
				НоваяЗапись.Объект = НоваяСтрока.Ссылка;
				НоваяЗапись.ВопросДляСобеседования = ВопросДляСобеседования.Ключ;
				Если ЗначениеЗаполнено(ТекущаяНастройка.ЭлементарныйВопрос) Тогда
					МассивЭлементарныхВопросов = ВопросДляСобеседования.Значение;
					Для Каждого СтруктураЭлементарногоВопроса Из МассивЭлементарныхВопросов Цикл
						Если СтруктураЭлементарногоВопроса.ЭлементарныйВопрос.Наименование <> ТекущаяНастройка.ЭлементарныйВопрос Тогда
							Продолжить;
						КонецЕсли;
						НоваяЗапись.ЭлементарныйВопрос = СтруктураЭлементарногоВопроса.ЭлементарныйВопрос;	
						Для Каждого Ответ Из СтруктураЭлементарногоВопроса.Ответы Цикл
							Если Ответ.Наименование = ТекущаяНастройка.ОтветНаВопрос Тогда
								НоваяЗапись.ОтветНаВопрос = Ответ;
								Прервать;
							КонецЕсли;
						КонецЦикла;
						Прервать;
					КонецЦикла;
				КонецЕсли;
				СтруктураХарактеристики = ХарактеристикиПерсонала.ХарактеристикаИзМакета(ТекущаяНастройка.ХарактеристикаПерсонала, ТекущаяНастройка.ЗначениеХарактеристики, БиблиотекаХарактеристикТаблица);
				Если СтруктураХарактеристики <> Неопределено Тогда
					НоваяЗапись.ХарактеристикаПерсонала = СтруктураХарактеристики.Характеристика;
					НоваяЗапись.ЗначениеХарактеристики = СтруктураХарактеристики.Значение;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(НоваяЗапись.ЭлементарныйВопрос) Тогда
					Для Каждого СтрокаКлючей Из НоваяЗапись.ВопросДляСобеседования.КлючевыеВопросы Цикл
						Если СтрокаКлючей.ЭлементарныйВопрос.Наименование <> ТекущаяНастройка.ЭлементарныйВопрос Тогда
							Продолжить;
						КонецЕсли;
						ОтветНаВопросВопросаДляСобеседования = Справочники.ВариантыОтветовАнкет.НайтиПоНаименованию(ТекущаяНастройка.ОтветНаВопрос, Истина,, СтрокаКлючей.ЭлементарныйВопрос);
						Если ЗначениеЗаполнено(ОтветНаВопросВопросаДляСобеседования) Тогда
							НоваяЗапись.ЭлементарныйВопросВопросаДляСобеседования = СтрокаКлючей.ЭлементарныйВопрос;
							НоваяЗапись.ОтветНаВопросВопросаДляСобеседования = ОтветНаВопросВопросаДляСобеседования;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				НоваяЗапись.Балл = ТекущаяНастройка.Балл;
				НоваяЗапись.Записать();
			КонецЦикла;
		КонецЦикла;		
				
		Если НомерСтроки = Элементы.ПрофилиДолжностей.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеПрофилей(СтандартнаяОбработка = Неопределено)
	
	СтандартнаяОбработка = Ложь;
	
	НовыхЭтапов = 0;
	НовыхВопросовДляСобеседования = 0;
	НовыхХарактеристик = 0;
	НовыхДействий = 0;
	НовыхДолжностей = 0;
	ПроверитьНеобходимостьСозданияНовых(Элементы.ПрофилиДолжностей.ВыделенныеСтроки, НовыхЭтапов, НовыхВопросовДляСобеседования, НовыхХарактеристик, НовыхДействий, НовыхДолжностей); 
	Если НовыхЭтапов + НовыхВопросовДляСобеседования + НовыхХарактеристик + НовыхДействий + НовыхДолжностей > 0 Тогда
		ТекстВопроса = НСтр("ru = 'При создании профилей из библиотеки также будут созданы элементы следующих справочников:'");
		Если НовыхДолжностей > 0 Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Должности: %1'"), Строка(НовыхДолжностей));
		КонецЕсли;
	    Если НовыхЭтапов > 0 Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Этапы работы: %1'"), Строка(НовыхЭтапов));
		КонецЕсли;
	    Если НовыхВопросовДляСобеседования > 0 Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вопросы для собеседования: %1'"), Строка(НовыхВопросовДляСобеседования));
		КонецЕсли;
		Если НовыхДействий > 0 Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Действия сотрудников: %1'"), Строка(НовыхДействий));
		КонецЕсли;
	    Если НовыхХарактеристик > 0 Тогда
			ТекстВопроса = ТекстВопроса + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Характеристики персонала: %1'"), Строка(НовыхХарактеристик));
		КонецЕсли;
		ТекстВопроса = ТекстВопроса + Символы.ПС + Символы.ПС + НСтр("ru = 'Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборВСпискеПрофилейЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;

	ТекущаяСсылка = Неопределено;
	СохранитьВыбранныеСтроки(Элементы.ПрофилиДолжностей.ВыделенныеСтроки, ТекущаяСсылка);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлены профили должностей'"));
	ОповеститьОВыборе(ТекущаяСсылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеПрофилейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСсылка = Неопределено;
	СохранитьВыбранныеСтроки(Элементы.ПрофилиДолжностей.ВыделенныеСтроки, ТекущаяСсылка);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлены профили должностей'"));
	ОповеститьОВыборе(ТекущаяСсылка);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ЭлементарныйВопрос(ЭлементарныйВопросСтрокой, НаименованиеПрофиля, ЭтапРаботы, ВопросШаблонаАнкеты, БиблиотекаОтветовТаблица)
	
	ЭлементарныйВопрос = ПланыВидовХарактеристик.ВопросыДляАнкетирования.СоздатьЭлемент();
	ЭлементарныйВопрос.Наименование = ЭлементарныйВопросСтрокой;
	ЭлементарныйВопрос.Формулировка = ЭлементарныйВопросСтрокой;
	ЭлементарныйВопрос.ТипОтвета = Перечисления.ТипыОтветовНаВопрос.ОдинВариантИз;
	ЭлементарныйВопрос.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ВариантыОтветовАнкет");
	ЭлементарныйВопрос.ВидПереключателя = Перечисления.ВидыПереключателяВАнкетах.Тумблер;
	ЭлементарныйВопрос.Записать();
	
	МассивОтветов = Новый Массив;
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Наименование", НаименованиеПрофиля);
	СтруктураПоиска.Вставить("ЭтапРаботы", ЭтапРаботы);
	СтруктураПоиска.Вставить("ВопросШаблонаАнкеты", ВопросШаблонаАнкеты);
	СтруктураПоиска.Вставить("ЭлементарныйВопрос", ЭлементарныйВопросСтрокой);
	СтрокиОтветов = БиблиотекаОтветовТаблица.НайтиСтроки(СтруктураПоиска);
	Для Каждого ТекущийОтвет Из СтрокиОтветов Цикл
		Ответ = Справочники.ВариантыОтветовАнкет.СоздатьЭлемент();
		Ответ.Наименование = ТекущийОтвет.Ответ;
		Ответ.Владелец = ЭлементарныйВопрос.Ссылка;
		Ответ.Записать();
		МассивОтветов.Добавить(Ответ.Ссылка);
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ЭлементарныйВопрос", ЭлементарныйВопрос.Ссылка);
	СтруктураВозврата.Вставить("Ответы", МассивОтветов);
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура ПроверитьНеобходимостьСозданияНовых(Знач ВыбранныеСтроки, НовыхЭтапов, НовыхВопросов, НовыхХарактеристик, НовыхДействий, НовыхДолжностей)
	
	МассивЭтапов = Новый Массив;
	МассивВопросов = Новый Массив;
	МассивХарактеристик = Новый Массив;
	МассивДействий = Новый Массив;
	МассивДолжностей = Новый Массив;
	
	БиблиотекаXML = Справочники.ВопросыДляСобеседования.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаXML).Данные;
	БиблиотекаТаблицаКлючевыхВопросов = БиблиотекаТаблица.Скопировать();
	БиблиотекаТаблицаКлючевыхВопросов.Свернуть("Наименование, ЭлементарныйВопрос, Предопределенный, ТребуетсяКомментарий, ПояснениеКомментария");
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = ПрофилиДолжностей[НомерСтроки];
		
		СтрокаВБазе = Справочники.ПрофилиДолжностей.НайтиПоНаименованию(ТекущиеДанные.Наименование, Истина);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Продолжить;
		КонецЕсли;
		
		Должность = Справочники.Должности.НайтиПоНаименованию(ТекущиеДанные.Должность, Истина);
		Если Не ЗначениеЗаполнено(Должность) Тогда
			Если МассивДолжностей.Найти(Должность) = Неопределено Тогда
				МассивДолжностей.Добавить(Должность);
			КонецЕсли;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
		СтрокиЗначений = ХарактеристикиПрофилей.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
			Если (Не ЗначениеЗаполнено(ТекущаяСтрока.Характеристика)) Или (МассивХарактеристик.Найти(ТекущаяСтрока.Характеристика) <> Неопределено) Тогда
				Продолжить;
			КонецЕсли;
			ЭлектронноеИнтервью.ПроверитьНовуюХарактеристику(ТекущаяСтрока.Характеристика, МассивХарактеристик);
		КонецЦикла;
		
		СтрокиДействий = ДействияСотрудников.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиДействий Цикл
			Если (Не ЗначениеЗаполнено(ТекущаяСтрока.ДействиеСотрудника)) Или (МассивДействий.Найти(ТекущаяСтрока.ДействиеСотрудника) <> Неопределено) Тогда
				Продолжить;
			КонецЕсли;
			ПроверитьНовоеДействие(ТекущаяСтрока.ДействиеСотрудника, МассивДействий, МассивХарактеристик);
		КонецЦикла;
		
		СтрокиЭтапов = ЭтапыРаботы.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЭтапов Цикл
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЭтапРаботы) Тогда
				Продолжить;
			КонецЕсли;
			ЭтапРаботы = Справочники.ЭтапыРаботыСКандидатами.НайтиПоНаименованию(ТекущаяСтрока.ЭтапРаботы, Истина);
			Если Не ЗначениеЗаполнено(ЭтапРаботы) Тогда
				Если МассивЭтапов.Найти(ТекущаяСтрока.ЭтапРаботы) = Неопределено Тогда
					МассивЭтапов.Добавить(ТекущаяСтрока.ЭтапРаботы);
				КонецЕсли;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
			СтруктураПоиска.Вставить("ЭтапРаботы", ТекущаяСтрока.ЭтапРаботы);
			СтрокиВопросов = ВопросыЭтапов.НайтиСтроки(СтруктураПоиска);
			Для Каждого ТекущийВопрос Из СтрокиВопросов Цикл
				Если ТекущийВопрос.ЭтоГруппа Тогда
					Продолжить;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ТекущийВопрос.ВопросДляСобеседования) Тогда
					Продолжить;
				КонецЕсли;
				Если МассивВопросов.Найти(ТекущийВопрос.ВопросДляСобеседования) = Неопределено Тогда
					ЕстьНовыйВопрос = ПроверитьНовыйВопрос(ТекущийВопрос.ВопросДляСобеседования, МассивВопросов, МассивХарактеристик, БиблиотекаТаблица, БиблиотекаТаблицаКлючевыхВопросов);
				Иначе
					ЕстьНовыйВопрос = Истина;
				КонецЕсли;
				Если ЕстьНовыйВопрос Тогда
					СтруктураПоиска = Новый Структура;
					СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
					СтруктураПоиска.Вставить("ВопросДляСобеседования", ТекущийВопрос.ВопросДляСобеседования); 
					СтрокиНастройки = НастройкиЭтапов.НайтиСтроки(СтруктураПоиска);
					Для Каждого ТекущаяНастройка Из СтрокиНастройки Цикл
						Если (Не ЗначениеЗаполнено(ТекущаяНастройка.ХарактеристикаПерсонала)) Или (МассивХарактеристик.Найти(ТекущаяНастройка.ХарактеристикаПерсонала) <> Неопределено) Тогда
							Продолжить;
						КонецЕсли;
						ЭлектронноеИнтервью.ПроверитьНовуюХарактеристику(ТекущаяНастройка.ХарактеристикаПерсонала, МассивХарактеристик);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;		
	КонецЦикла;
	
	НовыхЭтапов = МассивЭтапов.Количество();
	НовыхДействий = МассивДействий.Количество();
	НовыхВопросов = МассивВопросов.Количество();
	НовыхХарактеристик = МассивХарактеристик.Количество();
	НовыхДолжностей = МассивДолжностей.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНовоеДействие(ДействиеСотрудника, МассивДействий, МассивХарактеристик)
	
	ДействиеСотрудникаСсылка = Справочники.ДействияСотрудников.НайтиПоНаименованию(ДействиеСотрудника, Истина);
	Если ЗначениеЗаполнено(ДействиеСотрудникаСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	БиблиотекаXML = Справочники.ДействияСотрудников.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаXML).Данные;
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Наименование", ДействиеСотрудника);
	СтрокиДействия = БиблиотекаТаблица.НайтиСтроки(СтруктураПоиска);
	Если СтрокиДействия.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивДействий.Добавить(ДействиеСотрудника);
	
	Для Каждого ТекущаяСтрока Из СтрокиДействия Цикл
		Если (Не ЗначениеЗаполнено(ТекущаяСтрока.Характеристика)) Или (МассивХарактеристик.Найти(ТекущаяСтрока.Характеристика) <> Неопределено) Тогда
			Продолжить;
		КонецЕсли;
		ЭлектронноеИнтервью.ПроверитьНовуюХарактеристику(ТекущаяСтрока.Характеристика, МассивХарактеристик);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьНовыйВопрос(ВопросДляСобеседованияСтрокой, МассивВопросов, МассивХарактеристик, БиблиотекаТаблица, БиблиотекаТаблицаКлючевыхВопросов)
	
	ВопросСсылка = Справочники.ВопросыДляСобеседования.НайтиПоНаименованию(ВопросДляСобеседованияСтрокой, Истина);
	Если ЗначениеЗаполнено(ВопросСсылка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Наименование", ВопросДляСобеседованияСтрокой);
	СтрокиКлючей = БиблиотекаТаблица.НайтиСтроки(СтруктураПоиска);
	Если СтрокиКлючей.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МассивВопросов.Добавить(ВопросДляСобеседованияСтрокой);
	
	СтрокиВопросов = БиблиотекаТаблицаКлючевыхВопросов.НайтиСтроки(СтруктураПоиска);
	Для Каждого ТекущаяСтрока Из СтрокиВопросов Цикл
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЭлементарныйВопрос) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Наименование", ВопросДляСобеседованияСтрокой);
		СтруктураПоиска.Вставить("ЭлементарныйВопрос", ТекущаяСтрока.ЭлементарныйВопрос);
		СтрокиКлючей = БиблиотекаТаблица.НайтиСтроки(СтруктураПоиска);
		Для Каждого СтрокаКлючей Из СтрокиКлючей Цикл
			Если (Не ЗначениеЗаполнено(СтрокаКлючей.ХарактеристикаПерсонала)) Или (МассивХарактеристик.Найти(СтрокаКлючей.ХарактеристикаПерсонала) <> Неопределено) Тогда
				Продолжить;
			КонецЕсли;
			ЭлектронноеИнтервью.ПроверитьНовуюХарактеристику(СтрокаКлючей.ХарактеристикаПерсонала, МассивХарактеристик);
		КонецЦикла;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

#КонецОбласти