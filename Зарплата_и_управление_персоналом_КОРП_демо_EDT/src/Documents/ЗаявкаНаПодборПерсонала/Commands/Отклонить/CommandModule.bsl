
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОтклонитьЗаявки(ПараметрКоманды);
	ОповеститьОбИзменении(Тип("ДокументСсылка.ЗаявкаНаПодборПерсонала"));
КонецПроцедуры

&НаСервере
Процедура ОтклонитьЗаявки(Заявки)
	Документы.ЗаявкаНаПодборПерсонала.ОтклонитьЗаявки(Заявки);
КонецПроцедуры

#КонецОбласти