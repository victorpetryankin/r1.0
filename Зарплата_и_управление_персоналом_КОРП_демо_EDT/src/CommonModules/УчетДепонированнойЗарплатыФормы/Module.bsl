////////////////////////////////////////////////////////////////////////////////
// Учет депонированной зарплаты.
// Серверные процедуры и функции форм документов.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииФормДокументаДепонированиеЗарплаты

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМ

// Обработчик события ПриСозданииНаСервере.
// 	Устанавливает первоначальные значения реквизитов объекта.
//	Инициализирует реквизиты формы.
//
// Параметры:
// 	Форма - УправляемаяФорма - форма, которая создается.
// 	Отказ - Булево - признак отказа от создания формы.
// 	СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ДепонированиеЗарплатыПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	УчетДепонированнойЗарплатыФормыВнутренний.ДепонированиеЗарплатыПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка)
КонецПроцедуры

#КонецОбласти

#КонецОбласти
