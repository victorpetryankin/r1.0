#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем МенеджерВременныхТаблиц;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УчетРабочегоВремениРасширенный.КонтрольИзмененияДанныхРегистровПередЗаписью(ЭтотОбъект, МенеджерВременныхТаблиц);
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеРегистра = РегистрыНакопления.ДанныеОперативногоУчетаРабочегоВремениСотрудников.ОписаниеРегистра();
	
	УчетРабочегоВремениРасширенный.ЗаписатьПараметрыРегистрируемыхДанных(Отбор.Регистратор.Значение, ОписаниеРегистра);
	
	ДанныеИзменены = Ложь;
	
	УчетРабочегоВремениРасширенный.КонтрольИзмененияДанныхРегистровПриЗаписи(ЭтотОбъект, МенеджерВременныхТаблиц, ДанныеИзменены);
	
	Если ДанныеИзменены Тогда
		УчетРабочегоВремениРасширенный.РегистрРассчитанныхДанныхПриИзмененииИсточниковДанных(МенеджерВременныхТаблиц);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
