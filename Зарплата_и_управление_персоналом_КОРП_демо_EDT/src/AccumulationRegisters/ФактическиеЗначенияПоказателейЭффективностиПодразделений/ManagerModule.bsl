#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс		

Функция ТаблицаИзмеренийПланаПодразделений() Экспорт

	Таблица = Новый ТаблицаЗначений;
	
	Таблица.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата"));
	Таблица.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));
	Таблица.Колонки.Добавить("Подразделение", Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	Таблица.Колонки.Добавить("Показатель", Новый ОписаниеТипов("СправочникСсылка.СтруктураЦелей"));
	
	Возврат Таблица;

КонецФункции
 
#КонецОбласти

#КонецЕсли
