#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда	
	ЭлектронноеОбучениеСлужебный.ИсключитьЗначенияПеречисленияИзСпискаВыбора(Параметры, ДанныеВыбора, "ТипыНавигацииСтраницЭлектронногоКурса", СтандартнаяОбработка);
	#КонецЕсли
	Возврат;
КонецПроцедуры

#КонецОбласти
