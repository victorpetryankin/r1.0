#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	ИспользоватьНачислениеЗарплаты = Константы.ИспользоватьНачислениеЗарплаты.Получить();
	
	ЭтотОбъект[0].НеИспользоватьШтатноеРасписание = Не ЭтотОбъект[0].ИспользоватьШтатноеРасписание;
	ЭтотОбъект[0].НеИспользоватьИсториюИзмененияШтатногоРасписания = Не ЭтотОбъект[0].ИспользоватьИсториюИзмененияШтатногоРасписания;
	ЭтотОбъект[0].НеИспользоватьВилкуСтавокВШтатномРасписании = ИспользоватьНачислениеЗарплаты И Не ЭтотОбъект[0].ИспользоватьВилкуСтавокВШтатномРасписании;
	
	ЭтотОбъект[0].ИспользоватьИндексациюШтатногоРасписания = ПолучитьФункциональнуюОпцию("ИспользоватьИндексациюЗаработка") И ЭтотОбъект[0].ИспользоватьИсториюИзмененияШтатногоРасписания;
	
	Если Не ЭтотОбъект[0].ИспользоватьШтатноеРасписание Тогда
		ЭтотОбъект[0].ИспользоватьБронированиеПозиций = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	Если Константы.РаботаВБюджетномУчреждении.Получить() Тогда
		ЭтотОбъект[0].ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
