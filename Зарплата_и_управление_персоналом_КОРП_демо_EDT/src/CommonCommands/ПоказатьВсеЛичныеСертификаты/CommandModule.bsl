
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработкаКоманды_Завершение", 
		ЭтотОбъект);
		
	КриптографияЭДКОКлиент.ВыбратьСертификат(ОписаниеОповещения, Ложь,,"My",,,,,Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКоманды_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	// Заглушка, так как в функции описание оповещения обязательно
	ЭтоЗаглушка = Истина;
	
КонецПроцедуры

#КонецОбласти


