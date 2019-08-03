
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НаименованиеОрганизации = "";
	
	Если Параметры.Отбор.Свойство("ГоловнаяОрганизация") Тогда
		
		ВыборПоГоловнойОрганизации = Истина;
		Если Не ЗначениеЗаполнено(Параметры.Отбор.ГоловнаяОрганизация) Тогда
			Параметры.Отбор.Удалить("ГоловнаяОрганизация");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
			ВыборПоГоловнойОрганизации = Ложь;
		Иначе
			Параметры.Отбор.Удалить("Организация");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Роль") И ЗначениеЗаполнено(Параметры.Отбор.Роль) Тогда
		
		Если ТипЗнч(Параметры.Отбор.Роль) = Тип("Массив") Тогда
			РольФизическогоЛица = Новый ФиксированныйМассив(Параметры.Отбор.Роль);
		Иначе
			РольФизическогоЛица = Параметры.Отбор.Роль;
		КонецЕсли;
		
		Параметры.Отбор.Удалить("Роль");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Роль", РольФизическогоЛица);
		
	Иначе
		
		РольФизическогоЛица = Перечисления.РолиФизическихЛиц.ПустаяСсылка();
		
		Если Параметры.Отбор.Свойство("Роль") Тогда
			Параметры.Отбор.Удалить("Роль");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Организация = Параметры.Отбор.Организация;
	ИначеЕсли Параметры.Отбор.Свойство("ГоловнаяОрганизация") Тогда
		Организация = Параметры.Отбор.ГоловнаяОрганизация;
	Иначе
		
		ЗапрашиваемыеЗначения = Новый Структура("Организация", "Организация");
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения);
		
		Если ВыборПоГоловнойОрганизации И ЗначениеЗаполнено(Организация) Тогда
			Организация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Организация);
			Параметры.Отбор.Вставить("ГоловнаяОрганизация", Организация);
		Иначе
			Параметры.Отбор.Вставить("Организация", Организация);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ВызватьИсключение НСтр("ru='Необходимо указать организацию'");
	КонецЕсли;
	
	НаименованиеОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	
	Если ТипЗнч(РольФизическогоЛица) = Тип("ФиксированныйМассив") Тогда
		РольВоМножественномЧисле = НСтр("ru = 'Получатели доходов'");
	Иначе
		РольВоМножественномЧисле = ФизическиеЛицаЗарплатаКадрыРасширенный.ПредставлениеРолиВоМножественномЧисле(РольФизическогоЛица);
	КонецЕсли;
	
	Заголовок = РольВоМножественномЧисле + " (" + НаименованиеОрганизации +")";
	
	КомандаУдалитьИзСпискаЗаголовок = "";
	КомандаУдалитьИзСпискаВидимость = Истина;
	
	Если РольФизическогоЛица = Перечисления.РолиФизическихЛиц.Акционер Тогда
		
		Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок = НСтр("ru = 'Выбирать из полного списка физических лиц'");
		
		Элементы.Инфонадпись.Заголовок = 
			НСтр("ru = 'Сейчас в списке отображаются только те акционеры, которые ранее уже вводились в документы. 
					|Вы можете создать нового акционера.
					|Не создавайте нового акционера если он является сотрудником организации и уже введен в систему - просто установите флажок ""Выбирать из состава сотрудников"".'");
					
		КомандаУдалитьИзСпискаЗаголовок = НСтр("ru = 'Удалить из списка акционеров'");
					
	ИначеЕсли РольФизическогоЛица = Перечисления.РолиФизическихЛиц.Сотрудник Тогда
		
		Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок = НСтр("ru = 'Выбирать из полного списка лиц'");
		
		Элементы.Инфонадпись.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В списке отображаются только те лица, с которыми заключались трудовые договора или договора на выполнение работ.
					|Для того, чтобы снять это ограничение, установите флажок ""%1"".'"),
				Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок);
				
		КомандаУдалитьИзСпискаВидимость = Ложь;
			
	ИначеЕсли РольФизическогоЛица = Перечисления.РолиФизическихЛиц.БывшийСотрудник Тогда
		
		Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок = НСтр("ru = 'Выбирать из полного списка сотрудников'");
		
		Элементы.Инфонадпись.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В списке отображаются только те сотрудники, которым ранее уже выполнялись выплаты после прекращения трудового договора (увольнения).
					|Для того, чтобы снять это ограничение, установите флажок ""%1"".'"),
				Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок);
				
		КомандаУдалитьИзСпискаЗаголовок = НСтр("ru = 'Удалить из списка бывших сотрудников'");
			
	ИначеЕсли РольФизическогоЛица = Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов
		Или ТипЗнч(РольФизическогоЛица) = Тип("ФиксированныйМассив") Тогда
		
		Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок = НСтр("ru = 'Выбирать из полного списка физических лиц'");
		
		Элементы.Инфонадпись.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В списке отображаются только те лица, которые ранее уже получали доходы.
					|Для того, чтобы снять это ограничение, установите флажок ""%1"".'"),
				Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок);

		КомандаУдалитьИзСпискаЗаголовок = НСтр("ru = 'Удалить из списка получателей доходов'");
		
	ИначеЕсли РольФизическогоЛица = Перечисления.РолиФизическихЛиц.РаздатчикЗарплаты Тогда
		
		Элементы.Инфонадпись.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В списке отображаются только те раздатчики зарплаты, которые ранее уже выбирались.
					|Для того, чтобы выбрать раздатчика зарплаты из полного списка сотрудников, установите флажок ""%1"".'"),
				Элементы.ВыбиратьИзСотрудниковОрганизации.Заголовок);

		КомандаУдалитьИзСпискаЗаголовок = НСтр("ru = 'Удалить из списка раздатчиков'");
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Список",
			"ИзменятьСоставСтрок",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСоздать",
			"Видимость",
			Ложь);
			
	ИначеЕсли ЗначениеЗаполнено(РольФизическогоЛица) Тогда
		
		РольВРодительномПадеже = ФизическиеЛицаЗарплатаКадрыРасширенный.ПредставлениеРолиВРодительномПадеже(РольФизическогоЛица);
		
		Элементы.Инфонадпись.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сейчас в списке отображаются только те %1, которые ранее уже вводились в документы. 
				|Вы можете создать нового %2.
				|Не создавайте нового %3 если он является сотрудником организации и уже введен в систему - просто установите флажок ""Выбирать из состава сотрудников"".'"), 
			НРег(РольВоМножественномЧисле), 
			РольВРодительномПадеже,
			РольВРодительномПадеже);

		КомандаУдалитьИзСпискаЗаголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Удалить из списка %1'"), РольВоМножественномЧисле);
				
	Иначе
				
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"НадписиГруппа",
			"Видимость",
			Ложь);
				
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокУдалитьИзСписка",
		"Заголовок",
		КомандаУдалитьИзСпискаЗаголовок);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокУдалитьИзСписка",
		"Видимость",
		КомандаУдалитьИзСпискаВидимость);
	
	Если Параметры.РежимВыбора И Параметры.ЗакрыватьПриВыборе = Ложь Тогда
		Элементы.Список.МножественныйВыбор = Истина;
		Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
	КонецЕсли;
	
	АдресСпискаПодобранныхФизическихЛиц = "";
	Если Параметры.Свойство("АдресСпискаПодобранныхФизическихЛиц", АдресСпискаПодобранныхФизическихЛиц) Тогда
		Если НЕ ПустаяСтрока(АдресСпискаПодобранныхФизическихЛиц) Тогда
			СписокПодобранных.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(АдресСпискаПодобранныхФизическихЛиц));
		КонецЕсли; 
	КонецЕсли;
	
	УстановитьСписокПодобранныхФизическихЛиц();
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьЗапросДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ВыбранныеФизическиеЛица.Количество() > 0 Тогда
		ОповеститьОВыборе(ВыбранныеФизическиеЛица.ВыгрузитьЗначения());
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ЭтотОбъект.ЗакрыватьПриВыборе И ИмяСобытия = "СозданоФизическоеЛицо" И Источник = Элементы.Список Тогда
		ОповеститьОВыборе(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбиратьИзСотрудниковОрганизацииПриИзменении(Элемент)
	
	ИзменитьСоставФизическихЛиц();
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбиратьИзСоставаСотрудников Тогда
		ЗаписатьНовуюРоль(Значение);
	КонецЕсли;
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		СписокЗначений = Значение;
	Иначе
		СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	КонецЕсли;
	
	Если СписокЗначений.Количество() > 0 Тогда
		
		Если Элементы.Список.МножественныйВыбор Тогда
			
			ОбновитьСписокПодобранных(СписокЗначений);
			Если СписокЗначений.Количество() > 1 Тогда
				Закрыть();
			КонецЕсли; 
			
		Иначе
			
			Если СписокПодобранных.НайтиПоЗначению(СписокЗначений[0]) = Неопределено Тогда
				ОповеститьОВыборе(СписокЗначений[0]);
			Иначе
				Закрыть();
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ЗначениеЗаполнено(РольФизическогоЛица) Тогда
		
		Отказ = Истина;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РольФизическогоЛица", РольФизическогоЛица);
		ПараметрыОткрытия.Вставить("Организация", Организация);
		ПараметрыОткрытия.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыОткрытия, Элемент);

	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзСписка(Команда)
	
	УдалитьИзСпискаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	УстановитьЗапросДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИзменитьСоставФизическихЛиц()
	
	Если ТипЗнч(РольФизическогоЛица) = Тип("ФиксированныйМассив") Тогда
		РольФизическогоЛицаДляПроверки = Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов;
	Иначе
		РольФизическогоЛицаДляПроверки = РольФизическогоЛица;
	КонецЕсли;
	
	Если ВыбиратьИзСоставаСотрудников Тогда
		
		Если РольФизическогоЛицаДляПроверки <> Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов
			И РольФизическогоЛицаДляПроверки <> Перечисления.РолиФизическихЛиц.Акционер Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Роль", Перечисления.РолиФизическихЛиц.Сотрудник);
			
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Роль");
		КонецЕсли;
		
		Если РольФизическогоЛицаДляПроверки = Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов
			ИЛИ РольФизическогоЛицаДляПроверки = Перечисления.РолиФизическихЛиц.Акционер Тогда
			
			Если ВыборПоГоловнойОрганизации Тогда
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ГоловнаяОрганизация");
			Иначе
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Организация");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Роль", РольФизическогоЛица);
	КонецЕсли;
	
	Если НЕ ВыбиратьИзСоставаСотрудников
		ИЛИ РольФизическогоЛицаДляПроверки <> Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов
			И РольФизическогоЛицаДляПроверки <> Перечисления.РолиФизическихЛиц.Акционер Тогда
		
		Если ВыборПоГоловнойОрганизации Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ГоловнаяОрганизация", Организация);
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация);
		КонецЕсли;
		
	КонецЕсли; 
	
	УстановитьЗапросДинамическогоСписка();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНовуюРоль(Знач ФизическоеЛицо)
	
	Если ТипЗнч(РольФизическогоЛица) = Тип("ПеречислениеСсылка.РолиФизическихЛиц") Тогда
		НазначаемаяРоль = РольФизическогоЛица;
	Иначе
		НазначаемаяРоль = Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов;
	КонецЕсли;
	
	РегистрыСведений.РолиФизическихЛиц.УстановитьРольФизическогоЛица(
		ФизическоеЛицо, Организация, НазначаемаяРоль);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьИзСпискаНаСервере()
	
	РегистрыСведений.РолиФизическихЛиц.УдалитьРольФизическогоЛица(
		Элементы.Список.ТекущаяСтрока, Организация, РольФизическогоЛица);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодобранных(Значение)
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		СписокЗначений = Значение;
	Иначе
		СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	КонецЕсли;
	
	Для каждого ВыбранноеЗначение Из СписокЗначений Цикл
		Если СписокПодобранных.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
			СписокПодобранных.Добавить(ВыбранноеЗначение);
			ВыбранныеФизическиеЛица.Добавить(ВыбранноеЗначение);
		КонецЕсли; 
	КонецЦикла;
	
	УстановитьСписокПодобранныхФизическихЛиц();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокПодобранныхФизическихЛиц()
	
	ЭлементУсловногоОформления = Неопределено;
	Для каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru='Выделение подобранных'") Тогда
			ЭлементУсловногоОформления = ЭлементОформления;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ЭлементУсловногоОформления <> Неопределено Тогда
		ЭлементУсловногоОформления.Отбор.Элементы[0].ПравоеЗначение = СписокПодобранных;
	КонецЕсли; 
		
КонецПроцедуры

&НаСервере
Процедура УстановитьЗапросДинамическогоСписка()
	
	НастройкиСписка = Новый Структура;
	
	НастройкиСписка.Вставить("УстановленОтборПоРоли", Ложь);
	НастройкиСписка.Вставить("УстановленОтборПоОрганизации", Ложь);
	
	НастройкиСписка.Вставить("ОтборПоРоли");
	НастройкиСписка.Вставить("ОтборПоОрганизации");
	
	НастройкиСписка.Вставить("ОтборыСписка", Новый Массив);
	
	КоллекцияОтборов = Новый Массив;
	КоллекцияОтборов.Добавить(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы);
	КоллекцияОтборов.Добавить(Список.КомпоновщикНастроек.Настройки.Отбор.Элементы);
	КоллекцияОтборов.Добавить(СотрудникиКлиентСерверРасширенный.ПользовательскиеОтборы(Список));
	
	Для каждого ЭлементыОтбора Из КоллекцияОтборов Цикл
		
		Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			
			Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли; 
			
			Если ЭлементОтбора.Использование Тогда
				
				Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) <> Тип("ПолеКомпоновкиДанных") Тогда
					
					ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
						НастройкиСписка.ОтборыСписка, Строка(ЭлементОтбора.ЛевоеЗначение),
						СотрудникиФормыРасширенный.ВидСравненияЗапроса(ЭлементОтбора.ВидСравнения), ЭлементОтбора.ПравоеЗначение);
					
				КонецЕсли;
				
				Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Роль") Тогда
					НастройкиСписка.УстановленОтборПоРоли = Истина;
					НастройкиСписка.ОтборПоРоли = ЭлементОтбора.ПравоеЗначение;
				КонецЕсли; 
				
				Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
					НастройкиСписка.УстановленОтборПоОрганизации = Истина;
					НастройкиСписка.ОтборПоОрганизации = ЭлементОтбора.ПравоеЗначение;
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если Не СотрудникиФормыРасширенный.ОтборыУстанавливались(ЭтаФорма, ОбщегоНазначенияКлиентСервер.СкопироватьМассив(НастройкиСписка.ОтборыСписка)) Тогда
		
		ЗапросСписка = ЗапросДинамическогоСписка(НастройкиСписка.ОтборыСписка);
		Если ЗапросСписка.Параметры.Количество() > 0 Тогда
			
			Список.ТекстЗапроса = ЗапросСписка.Текст;
			Для каждого ПараметрЗапроса Из ЗапросСписка.Параметры Цикл
				
				ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
					Список, ПараметрЗапроса.Ключ, ПараметрЗапроса.Значение);
				
			КонецЦикла;
			
		КонецЕсли;
		
		УстановленныеОтборыСписка = Новый ФиксированныйМассив(НастройкиСписка.ОтборыСписка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапросДинамическогоСписка(ОтборыСписка)
	
	Запрос = Новый Запрос;
	ТекстОтбораДанных = "";
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникФизическиеЛица.Ссылка,
		|	СправочникФизическиеЛица.ПометкаУдаления,
		|	СправочникФизическиеЛица.Родитель,
		|	СправочникФизическиеЛица.ЭтоГруппа,
		|	СправочникФизическиеЛица.Код,
		|	СправочникФизическиеЛица.Наименование,
		|	СправочникФизическиеЛица.ДатаРождения,
		|	СправочникФизическиеЛица.Пол,
		|	СправочникФизическиеЛица.ИНН,
		|	СправочникФизическиеЛица.СтраховойНомерПФР,
		|	СправочникФизическиеЛица.МестоРождения,
		|	СправочникФизическиеЛица.ГруппаДоступа,
		|	СправочникФизическиеЛица.ИмеетНаучныеТруды,
		|	СправочникФизическиеЛица.ИмеетИзобретения,
		|	РолиФизическихЛиц.Организация,
		|	РолиФизическихЛиц.Роль,
		|	РолиФизическихЛиц.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ИЗ
		|	Справочник.ФизическиеЛица КАК СправочникФизическиеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РолиФизическихЛиц КАК РолиФизическихЛиц
		|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ ПЕРВЫЕ 0
		|				1 КАК Поле1
		|			ГДЕ
		|				1 В (&ПараметрЗапроса01)
		|				И 1 В (&ПараметрЗапроса02)
		|				И 1 В (&ПараметрЗапроса03)
		|				И 1 В (&ПараметрЗапроса04)
		|				И 1 В (&ПараметрЗапроса05)
		|				И 1 В (&ПараметрЗапроса06)
		|				И 1 В (&ПараметрЗапроса07)
		|				И 1 В (&ПараметрЗапроса08)
		|				И 1 В (&ПараметрЗапроса09)
		|				И 1 В (&ПараметрЗапроса10)
		|				И 1 В (&ПараметрЗапроса11)
		|				И 1 В (&ПараметрЗапроса12)
		|				И 1 В (&ПараметрЗапроса13)
		|				И 1 В (&ПараметрЗапроса14)
		|				И 1 В (&ПараметрЗапроса15)
		|				И 1 В (&ПараметрЗапроса16)
		|				И 1 В (&ПараметрЗапроса17)
		|				И 1 В (&ПараметрЗапроса18)
		|				И 1 В (&ПараметрЗапроса19)
		|				И 1 В (&ПараметрЗапроса20)) КАК ТаблицаПараметров
		|			ПО (ИСТИНА)
		|		ПО СправочникФизическиеЛица.Ссылка = РолиФизическихЛиц.ФизическоеЛицо
		|			И (РолиФизическихЛиц.ИдентификаторЗаписи В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					РолиФизическихЛицОтбор.ИдентификаторЗаписи
		|				ИЗ
		|					РегистрСведений.РолиФизическихЛиц КАК РолиФизическихЛицОтбор
		|				ГДЕ
		|					РолиФизическихЛицОтбор.ФизическоеЛицо = СправочникФизическиеЛица.Ссылка
		|					И &ТекстОтбораДанных))";
		
	НомерПараметра = 1;
	Для каждого ЭлементОтбора Из ОтборыСписка Цикл
		
		ПозицияТочки = СтрНайти(ЭлементОтбора.ЛевоеЗначение, ".");
		Если ПозицияТочки = 0 Тогда
			ПолеВВерхнемРегистре = ВРег(ЭлементОтбора.ЛевоеЗначение);
		Иначе
			ПолеВВерхнемРегистре = ВРег(Прав(ЭлементОтбора.ЛевоеЗначение, ПозицияТочки - 1));
		КонецЕсли;
		
		Если ПолеВВерхнемРегистре = ВРег("Организация")
			Или ПолеВВерхнемРегистре = ВРег("ГоловнаяОрганизация")
			Или ПолеВВерхнемРегистре = ВРег("Роль") Тогда
			
			Если Не ПустаяСтрока(ТекстОтбораДанных) Тогда
				ТекстОтбораДанных = ТекстОтбораДанных + Символы.ПС + "И ";
			КонецЕсли;
			
			ИмяПараметра = "ПараметрЗапроса" + Формат(НомерПараметра, "ЧЦ=2; ЧВН=");
			
			Если ПолеВВерхнемРегистре = ВРег("ГоловнаяОрганизация") Тогда
				ЛевоеЗначение = "Организация.ГоловнаяОрганизация";
			Иначе
				ЛевоеЗначение = ЭлементОтбора.ЛевоеЗначение;
			КонецЕсли;
			
			ТекстОтбораДанных = ТекстОтбораДанных + "РолиФизическихЛицОтбор." + ЛевоеЗначение;
			ТекстОтбораДанных = ТекстОтбораДанных + " " + ЭлементОтбора.ВидСравнения + " ";
			ТекстОтбораДанных = ТекстОтбораДанных + "(&" + ИмяПараметра + ")";
			
			Запрос.УстановитьПараметр(ИмяПараметра, ЭлементОтбора.ПравоеЗначение);
			
			НомерПараметра = НомерПараметра + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для НомерНеЗаданногоПараметра = НомерПараметра По 20 Цикл
		ИмяПараметра = "ПараметрЗапроса" + Формат(НомерНеЗаданногоПараметра, "ЧЦ=2; ЧВН=");
		Запрос.УстановитьПараметр(ИмяПараметра, Null);
	КонецЦикла;
	
	Если ПустаяСтрока(ТекстОтбораДанных) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ТекстОтбораДанных", "");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстОтбораДанных", "(" + ТекстОтбораДанных + ")");
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти
