
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = ВыбранноеЗначение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИзБиблиотеки(Команда)
	
	ОткрытьФорму("ПланВидовХарактеристик.ХарактеристикиПерсонала.Форма.БиблиотекаХарактеристикПерсонала", , ЭтотОбъект);	
	
КонецПроцедуры

#КонецОбласти