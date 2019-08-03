
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		СотрудникиКлиентСервер.УстановитьРежимТолькоПросмотрВФормеРедактированияИстории(ЭтотОбъект);
	КонецЕсли;
		
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Элемент.ТекущиеДанные.ФизическоеЛицо = ОбъектВладелец;
			НовыйПериод = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			Если НаборЗаписей.Количество() > 1 Тогда
				ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
			Иначе
				ПоследнийПериод = '00010101000000';
			КонецЕсли; 
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = КонецДня(ПоследнийПериод) + 1;
			КонецЕсли; 
			Элемент.ТекущиеДанные.Период = НовыйПериод;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиент.УпорядочитьНаборЗаписейВФорме(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтотОбъект, "СостоянияВБракеФизическихЛиц", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЗаблокироватьОбъектВФормеВладельце()
	
	Возврат СотрудникиКлиент.ЗаблокироватьОбъектВФормеВладельцеПриРедактированииИстории(ЭтотОбъект);
	
КонецФункции

#КонецОбласти

