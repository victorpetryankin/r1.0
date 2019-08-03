#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Возвращает коллекцию вариантов настроек
//
// Возвращаемое значение:
//  Массив -  коллекция объектов со свойствами Имя и Представление (см. ВариантНастроекКомпоновкиДанных).
//
Функция ВариантыНастроек() Экспорт
	
	ВариантыНастроек = Новый Массив;
	
	ПоляНастройки = "Имя, Представление";
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "СравнительныйАнализЦелевыхПоказателейСотрудников",			НСтр("ru = 'Сравнительный анализ целевых показателей сотрудников'")));
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "ПлановыеИФактическиеЗначенияЦелевыхПоказателейСотрудников",	НСтр("ru = 'Плановые и фактические значения целевых показателей сотрудников'")));
	
	Возврат ВариантыНастроек;
	
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СравнительныйАнализЦелевыхПоказателейСотрудников");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сравнение фактических значений по одному показателю для нескольких сотрудников за разные периоды.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПлановыеИФактическиеЗначенияЦелевыхПоказателейСотрудников");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Изменение плановых и фактических значений по выбранному показателю'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли

