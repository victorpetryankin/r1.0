
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		Объект.Округление = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли	

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриПолученииДанныхНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ХарактерВыплатыПриИзменении(Элемент)
	НастроитьЭлементыФормы(ЭтаФорма)
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	НастроитьЭлементыФормы(ЭтаФорма)
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма) 
	Форма.Элементы.ВидДокументаОснования.АвтоОтметкаНезаполненного = Форма.Объект.ХарактерВыплаты = ПредопределенноеЗначение("Перечисление.ХарактерВыплатыЗарплаты.Межрасчет");
	Форма.Элементы.ВидДокументаОснования.ОтметкаНезаполненного = Форма.Элементы.ВидДокументаОснования.АвтоОтметкаНезаполненного И НЕ ЗначениеЗаполнено(Форма.Объект.ВидДокументаОснования)
КонецПроцедуры

#КонецОбласти

