
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("ЗаявкиТекущегоПользователя", Истина);
	ОткрытьФорму("ЖурналДокументов.ЗаявкиСотрудников.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ЗаявкиТекущегоПользователя", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти