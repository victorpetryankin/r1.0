#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	СписокФизическихЛиц = Новый Массив;
	Если ЭтотОбъект.Количество() Тогда
		СписокФизическихЛиц = ЭтотОбъект.ВыгрузитьКолонку("ФизическоеЛицо");
	Иначе
		Выборка = РегистрыСведений.СтандартныеВычетыНаДетейНДФЛ.ВыбратьПоРегистратору(ЭтотОбъект.Отбор.Регистратор.Значение);
		Пока Выборка.Следующий() Цикл
			СписокФизическихЛиц.Добавить(Выборка.ФизическоеЛицо);
		КонецЦикла;
	КонецЕсли;
	
	ЭтотОбъект.ДополнительныеСвойства.Вставить("ФизическиеЛица", СписокФизическихЛиц);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СписокФизическихЛиц = Неопределено;
	Если Не ЭтотОбъект.ДополнительныеСвойства.Свойство("ФизическиеЛица", СписокФизическихЛиц) Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СтандартныеВычетыПоНДФЛВторичный.ЗаполнитьВторичныеДанныеВычетыНаДетей(СписокФизическихЛиц);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли