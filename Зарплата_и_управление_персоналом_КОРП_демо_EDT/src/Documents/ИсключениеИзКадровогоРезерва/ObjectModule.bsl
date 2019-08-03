#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = Документы.ИсключениеИзКадровогоРезерва.ПолучитьДанныеДляПроведения(Ссылка);
	КадровыйРезерв.СформироватьДвиженияИсторииКадровогоРезерва(Движения, ДанныеДляПроведения, "ДвиженияИсторииКадровогоРезерва");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИсключения, "Объект.ДатаИсключения", Отказ, НСтр("ru='Дата исключения'"), , , Ложь);
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	КадровыйРезерв.ПроверитьЗаполнениеВидаРезерваВТабличнойЧасти(ЭтотОбъект, "Резерв", ПроверяемыеРеквизиты, Отказ);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйРезервПоВидам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидРезерва");
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаИсключения = НачалоДня(ДатаИсключения) + КадровыйРезерв.ЗначениеВремениПоСтатусуРезерва(ПредопределенноеЗначение("Перечисление.СостоянияСогласования.ПустаяСсылка"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	Возврат ОбменДаннымиЗарплатаКадрыРасширенный.ОграниченияРегистрацииПоПодразделениюИФизическомуЛицу(ЭтотОбъект, Подразделение, ФизическоеЛицо, ДатаИсключения);
КонецФункции

#КонецОбласти

#КонецЕсли