
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	СписокВидовОтчетов.ЗагрузитьЗначения(КонтекстЭДО.ПолучитьСписокОтчетовПоддерживающихПечатьИзЭлектронногоПредставления());
	
КонецПроцедуры

#КонецОбласти
