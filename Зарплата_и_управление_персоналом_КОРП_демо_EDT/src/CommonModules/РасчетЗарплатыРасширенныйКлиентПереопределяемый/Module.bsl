
#Область ПрограммныйИнтерфейс

// Процедура предназначена для описания действий, 
// выполняемых по команде расшифровки значения показателя.
//
// Команда расшифровки может использоваться для показателей, 
// значения которых рассчитываются нетривиальным образом, 
// и для пользователя может быть полезным продемонстрировать промежуточные этапы расчета, 
// отобразить дополнительную информацию и т.д.
//
// Параметры:
//	- Форма - управляемая форма документа, выполняющего начисление.
//	- ОписаниеТаблицы - описание таблицы документа с данными показателей.
//	- Элемент - таблица формы
//	- ВыбраннаяСтрока - идентификатор строки таблицы.
//	- Поле - поле формы, в котором размещена команда расшифровки.
//	- СтандартнаяОбработка - признак необходимости выполнения стандартной обработки, 
//							используется для отметки о выполнении команды расшифровки.
//	- ПересчитыватьСотрудника - признак необходимости выполнить расчет строк сотрудника в документе.
//
Процедура ВыполнитьКомандуРасшифровкиЗначенияПоказателя(Форма, ОписаниеТаблицы, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ПересчитыватьСотрудника) Экспорт
	
КонецПроцедуры

// Процедура предназначена для создания документа отражения в бухучете из обработки РасчетЗарплаты.
//
// Параметры:
//	Организация - выбранная в обработке организация.
//	МесяцНачисления - выбранный месяц.
//	СтандартнаяОбработка - признак необходимости выполнения стандартной обработки.
//
Процедура СоздатьДокументОтраженияВБухучете(Организация, МесяцНачисления, СтандартнаяОбработка) Экспорт 
	
КонецПроцедуры

#КонецОбласти
