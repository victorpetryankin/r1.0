#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора.
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//   ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотруднику(ЭтотОбъект, Организация, Сотрудник, Дата);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает признак завершенности работы с объектом.
Функция ОбъектЗафиксирован() Экспорт
	Возврат Проведен;
КонецФункции

// Процедура обновляет вторичные данные в документе с учетом фиксации.
Функция ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеСотрудника = Истина, ДанныеОЗаработке = Истина, ОбновлятьБезусловно = Истина) Экспорт
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() И Не ОбновлятьБезусловно Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	ПараметрыФиксации = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Метаданные().ПолноеИмя()).ПараметрыФиксацииВторичныхДанных();
	
	Если ДанныеОрганизации И ОбновитьДанныеСтрахователя(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ДанныеСотрудника И ОбновитьДанныеСотрудника(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция ОбновитьДанныеСтрахователя(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыДокумента = Новый Структура("РегистрационныйНомерФСС,ДополнительныйКодФСС,КодПодчиненностиФСС,НаименованиеТерриториальногоОрганаФСС,Руководитель,ДолжностьРуководителя,АдресОрганизации");
	
	СтрокаРеквизитыОрганизации = "РегистрационныйНомерФСС, КодПодчиненностиФСС, ДополнительныйКодФСС, НаименованиеТерриториальногоОрганаФСС";
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, СтрокаРеквизитыОрганизации);
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, РеквизитыОрганизации, СтрокаРеквизитыОрганизации);
	
	ЗаполняемыеЗначения = Новый Структура("Организация,Руководитель,ДолжностьРуководителя", Организация);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ЗаполняемыеЗначения.Свойство("Руководитель",          РеквизитыДокумента.Руководитель);
	ЗаполняемыеЗначения.Свойство("ДолжностьРуководителя", РеквизитыДокумента.ДолжностьРуководителя);
	
	АдресаОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организация),
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
		Дата);
	
	Если АдресаОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.АдресОрганизации = АдресаОрганизации[0].ЗначенияПолей;
	Иначе
		РеквизитыДокумента.АдресОрганизации = "";
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ОбновитьДанныеСотрудника(ПараметрыФиксации)
	КадровыеДанные = Новый Массив;
	КадровыеДанные.Добавить("ФизическоеЛицо");
	КадровыеДанные.Добавить("Фамилия");
	КадровыеДанные.Добавить("Имя");
	КадровыеДанные.Добавить("Отчество");
	КадровыеДанные.Добавить("СтраховойНомерПФР");
	КадровыеДанные.Добавить("АдресПоПрописке");
	КадровыеДанные.Добавить("АдресПоПропискеПредставление");
	
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), КадровыеДанные, Дата);
	Если КадровыеДанныеСотрудников.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудников[0];
	
	ФизическоеЛицо = КадровыеДанныеСотрудника["ФизическоеЛицо"];
	
	РеквизитыДокумента = Новый Структура("ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР,Адрес");
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, КадровыеДанныеСотрудника, "ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР");
	РеквизитыДокумента.Адрес = КадровыеДанныеСотрудника.АдресПоПрописке;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

#КонецОбласти

#КонецЕсли
