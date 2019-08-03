#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;

	ТекущаяДата = ТекущаяДатаСеанса();
	Если Месяц(ТекущаяДата) < 4 Тогда
		// Предлагаем сделать сверки за предыдущий год
		
		ПрошлыйГод 			 = КонецГода(ДобавитьМесяц(ТекущаяДата, - 12));
		
		ДатаОкончанияПериода = ПрошлыйГод;
		ДатаНачалаПериода 	 = НачалоГода(ДатаОкончанияПериода);
		
	Иначе
		// Предлагаем сделать сверки за текущий год
		
		ДатаОкончанияПериода = ТекущаяДата;
		ДатаНачалаПериода 	 = НачалоГода(ДатаОкончанияПериода);
		
	КонецЕсли;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате
		ИЛИ ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов Тогда
		ФорматОтвета = Перечисления.ФорматОтветаНаЗапросИОН.XML;
	Иначе
		ФорматОтвета = ПоследнийИспользуемыйФорматОтвета();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов
		ИЛИ ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом Тогда
		
		Ошибки = Новый Массив;
		Для Каждого СтрокаТаблицы Из ЗапрашиваемыеНалоги Цикл
			
			Если ЗначениеЗаполнено(СтрокаТаблицы.КБК) И СтрДлина(СтрокаТаблицы.КБК) <> 20 Тогда
				
				ТекстСообщения = НСтр("ru = 'Введено некорректное значение КБК %1
                                       |Длина КБК должна быть равна 20 символам'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаТаблицы.КБК);
				Ошибки.Добавить(ТекстСообщения);
				
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТаблицы.КБК) Тогда
				
				ТекстСообщения = НСтр("ru = 'Не заполнен КБК'");
				Ошибки.Добавить(ТекстСообщения);
				
			КонецЕсли;
			
			ОКАТОНевернойДлины = СтрДлина(СтрокаТаблицы.ОКАТО) <> 11 И СтрДлина(СтрокаТаблицы.ОКАТО) <> 8;
			Если ЗначениеЗаполнено(СтрокаТаблицы.ОКАТО) И ОКАТОНевернойДлины
				ИЛИ Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаТаблицы.ОКАТО) Тогда
				
				ТекстСообщения = НСтр("ru = 'Введено некорректное значение ОКАТО или ОКТМО %1
					|Код ОКАТО/ОКТМО должен иметь длину 8 или 11 и состоять только из цифр.'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаТаблицы.ОКАТО);
				Ошибки.Добавить(ТекстСообщения);
				
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТаблицы.ОКАТО) Тогда
				
				ТекстСообщения = НСтр("ru = 'Не заполнено ОКАТО или ОКТМО'");
				Ошибки.Добавить(ТекстСообщения);
				
			КонецЕсли;
				
		КонецЦикла;
		
		// Вывод полученнных ошибок. Только уникальные ошибки.
		Ошибки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Ошибки);
		Для каждого Ошибка Из Ошибки Цикл
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Ошибка, 
				ЭтотОбъект, 
				,
				,
				Отказ);
			
		КонецЦикла; 
		
		МассивНепроверяемыхРеквизитов.Добавить("ЗапрашиваемыеНалоги");
		МассивНепроверяемыхРеквизитов.Добавить("ЗапрашиваемыеНалоги.КБК");
		МассивНепроверяемыхРеквизитов.Добавить("ЗапрашиваемыеНалоги.ОКАТО");
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ЗапрашиваемыеНалоги");
		МассивНепроверяемыхРеквизитов.Добавить("ЗапрашиваемыеНалоги.КБК");
		МассивНепроверяемыхРеквизитов.Добавить("ЗапрашиваемыеНалоги.ОКАТО");
	КонецЕсли;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом Тогда
		Если Не ЗначениеЗаполнено(ДатаОкончанияПериода) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаПериода");
			МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияПериода");
			ТекстСообщения = НСтр("ru = 'Поле ""За год"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияПериода",, Отказ);
		КонецЕсли;		
	КонецЕсли;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОСостоянииРасчетовСБюджетом Тогда
		Если Не ЗначениеЗаполнено(ДатаОкончанияПериода) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаПериода");
			МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияПериода");
			ТекстСообщения = НСтр("ru = 'Поле ""На дату"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияПериода",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ДополнительныйПараметр");
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеПеречняБухгалтерскойИНалоговойОтчетности Тогда
		Если Не ЗначениеЗаполнено(ДополнительныйПараметр) Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Виды отчетов"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДополнительныйПараметр",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если (ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов")
		ИЛИ ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом"))
		И КоличествоНалогов = Перечисления.КоличествоНалоговДляСверкиИОН.Несколько
		И ЗапрашиваемыеНалоги.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Укажите налоги или КБК, по которым запрашивается сверка'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ЗапрашиваемыеНалоги",, Отказ);
			
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПоследнийИспользуемыйФорматОтвета()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ФорматОтвета
	|ИЗ
	|	Документ.ЗапросНаИнформационноеОбслуживаниеНалогоплательщика КАК ЗапросНаИнформационноеОбслуживаниеНалогоплательщика
	|ГДЕ
	|	ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ВидУслуги <> ЗНАЧЕНИЕ(Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате)
	|		И ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ВидУслуги <> ЗНАЧЕНИЕ(Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.Дата УБЫВ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Перечисления.ФорматОтветаНаЗапросИОН.RTF;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.ФорматОтвета;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли