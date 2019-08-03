#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ШтатныеСотрудники");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список сотрудников, работающих по трудовым договорам с окладами, 
		|сведениями об авансе, графиком работы и личной информацией'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЛичныеДанныеСотрудников");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Паспортные данные, ИНН, СНИЛС, дата рождения и прочие личные данные'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "УволенныеСотрудники");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список уволенных на заданную дату сотрудников'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти
	
#КонецЕсли