
#Область ОбработчикиКомандФормы

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаСервере
Процедура ЗакончитьРедактированиеНаСервере(ЭлектронныйКурс)
	
	РегистрыСведений.ПубликацииЭлектронныхКурсов.Опубликовать(ЭлектронныйКурс, Истина);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если ЭлектронноеОбучениеСлужебныйКлиент.ТекущиеДанныеТаблицыДоступны(Элементы.Список.ТекущиеДанные) Тогда
		ЗакончитьРедактированиеНаСервере(Элементы.Список.ТекущиеДанные.ЭлектронныйКурс);
		Оповестить("ВыполняетсяПубликацияЭлектронногоКурса",,ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

