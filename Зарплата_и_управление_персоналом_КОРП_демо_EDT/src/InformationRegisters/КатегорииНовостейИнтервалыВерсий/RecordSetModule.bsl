#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("ProductVersion")
				ИЛИ ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("PlatformVersion") Тогда
			// Все нормально.
		Иначе
			// Нестандартная категория.
			// Ошибку не выдавать - оставить как есть.
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("ProductVersion")
			ИЛИ ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("PlatformVersion") Тогда
			// Все нормально.
		Иначе
			// Нестандартная категория.
			// Ошибку не выдавать - оставить как есть.
		КонецЕсли;
	КонецЦикла;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Вызывается автоматически только из формы, при программной записи необходимо вызывать явно.
	ОбработкаПроверкиЗаполнения(Отказ, Новый Массив);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		// 1. Для категории "ProductVersion" проверять формат: 99.99.999.9999.
		// 2. Для категории "PlatformVersion" проверять формат: 99.99.999.9999.
		Если ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("ProductVersion")
				ИЛИ ВРег(ТекущаяЗапись.КатегорияНовостей.Код) = ВРег("PlatformVersion") Тогда
			// Проверка формата версий: только цифры, формат 99.99.999.9999.
			// Версия ОТ.
			ТекстСообщения = НСтр("ru='Формат значения версии ОТ (%ВерсияОТ%) должен быть 99.99.999.9999 %ПодробныйТекстОшибки%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВерсияОТ%", ТекущаяЗапись.ВерсияОТ);
			ПроверитьВерсию(ТекущаяЗапись.ВерсияОТ, ТекстСообщения, Отказ);
			// Версия ДО.
			ТекстСообщения = НСтр("ru='Формат значения версии ДО (%ВерсияДО%) должен быть 99.99.999.9999 %ПодробныйТекстОшибки%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВерсияДО%", ТекущаяЗапись.ВерсияДО);
			ПроверитьВерсию(ТекущаяЗапись.ВерсияДО, ТекстСообщения, Отказ);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверяет строку версии на формат 99.99.999.9999 и в случае несоответствия выдает ошибку.
//
// Параметры:
//  ВерсияСтрокой  - Строка;
//  ТекстСообщения - Строка;
//  Отказ          - Булево.
//
Процедура ПроверитьВерсию(ВерсияСтрокой, ТекстСообщения, Отказ)

	ВсеЦифры = ИнтернетПоддержкаПользователейКлиентСервер.ВсеЦифры();

	МассивСловВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(ВерсияСтрокой, ".");
	Если МассивСловВерсии.Количество() = 4 Тогда // 99.99.999.9999
		Для СловоВерсии=0 По МассивСловВерсии.Количество()-1 Цикл
			Если СловоВерсии=0 Тогда // 2 цифры
				Если СтрДлина(МассивСловВерсии[СловоВерсии]) <> 2 Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтрЗаменить(
						ТекстСообщения,
						"%ПодробныйТекстОшибки%",
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='(первое число версии %1 должно быть длиной 2 символа)'"),
							ВерсияСтрокой));
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Сообщить();
					Отказ = Истина;
					ВызватьИсключение Сообщение.Текст;
				Иначе // Только цифры?
					Для С=1 По СтрДлина(МассивСловВерсии[СловоВерсии]) Цикл
						ТекущийСимвол = Сред(МассивСловВерсии[СловоВерсии], С, 1);
						Если СтрНайти(ВсеЦифры, ТекущийСимвол) = 0 Тогда
							Сообщение = Новый СообщениеПользователю;
							Сообщение.Текст = СтрЗаменить(
								ТекстСообщения,
								"%ПодробныйТекстОшибки%",
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='(первое число версии %1 должно содержать только цифры, а найден символ %2)'"),
									ВерсияСтрокой,
									ТекущийСимвол));
							Сообщение.УстановитьДанные(ЭтотОбъект);
							Сообщение.Сообщить();
							Отказ = Истина;
							ВызватьИсключение Сообщение.Текст;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли СловоВерсии=1 Тогда // 2 цифры
				Если СтрДлина(МассивСловВерсии[СловоВерсии]) <> 2 Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтрЗаменить(
						ТекстСообщения,
						"%ПодробныйТекстОшибки%",
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='(второе число версии %1 должно быть длиной 2 символа)'"),
							ВерсияСтрокой));
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Сообщить();
					Отказ = Истина;
					ВызватьИсключение Сообщение.Текст;
				Иначе // Только цифры?
					Для С=1 По СтрДлина(МассивСловВерсии[СловоВерсии]) Цикл
						ТекущийСимвол = Сред(МассивСловВерсии[СловоВерсии], С, 1);
						Если СтрНайти(ВсеЦифры, ТекущийСимвол) = 0 Тогда
							Сообщение = Новый СообщениеПользователю;
							Сообщение.Текст = СтрЗаменить(
								ТекстСообщения,
								"%ПодробныйТекстОшибки%",
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='(второе число версии %1 должно содержать только цифры, а найден символ %2)'"),
									ВерсияСтрокой,
									ТекущийСимвол));
							Сообщение.УстановитьДанные(ЭтотОбъект);
							Сообщение.Сообщить();
							Отказ = Истина;
							ВызватьИсключение Сообщение.Текст;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли СловоВерсии=2 Тогда // 3 цифры
				Если СтрДлина(МассивСловВерсии[СловоВерсии]) <> 3 Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтрЗаменить(
						ТекстСообщения,
						"%ПодробныйТекстОшибки%",
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='(третье число версии %1 должно быть длиной 3 символа)'"),
							ВерсияСтрокой));
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Сообщить();
					Отказ = Истина;
					ВызватьИсключение Сообщение.Текст;
				Иначе // Только цифры?
					Для С=1 По СтрДлина(МассивСловВерсии[СловоВерсии]) Цикл
						ТекущийСимвол = Сред(МассивСловВерсии[СловоВерсии], С, 1);
						Если СтрНайти(ВсеЦифры, ТекущийСимвол) = 0 Тогда
							Сообщение = Новый СообщениеПользователю;
							Сообщение.Текст = СтрЗаменить(
								ТекстСообщения,
								"%ПодробныйТекстОшибки%",
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='(третье число версии %1 должно содержать только цифры, а найден символ %2)'"),
									ВерсияСтрокой,
									ТекущийСимвол));
							Сообщение.УстановитьДанные(ЭтотОбъект);
							Сообщение.Сообщить();
							Отказ = Истина;
							ВызватьИсключение Сообщение.Текст;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли СловоВерсии=3 Тогда // 4 цифры
				Если СтрДлина(МассивСловВерсии[СловоВерсии]) <> 4 Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтрЗаменить(
						ТекстСообщения,
						"%ПодробныйТекстОшибки%",
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='(четвертое число версии %1 должно быть длиной 4 символа)'"),
							ВерсияСтрокой));
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Сообщить();
					Отказ = Истина;
					ВызватьИсключение Сообщение.Текст;
				Иначе // Только цифры?
					Для С=1 По СтрДлина(МассивСловВерсии[СловоВерсии]) Цикл
						ТекущийСимвол = Сред(МассивСловВерсии[СловоВерсии], С, 1);
						Если СтрНайти(ВсеЦифры, ТекущийСимвол) = 0 Тогда
							Сообщение = Новый СообщениеПользователю;
							Сообщение.Текст = СтрЗаменить(
								ТекстСообщения,
								"%ПодробныйТекстОшибки%",
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='(четвертое число версии %1 должно содержать только цифры, а найден символ %2)'"),
									ВерсияСтрокой,
									ТекущийСимвол));
							Сообщение.УстановитьДанные(ЭтотОбъект);
							Сообщение.Сообщить();
							Отказ = Истина;
							ВызватьИсключение Сообщение.Текст;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрЗаменить(
			ТекстСообщения,
			"%ПодробныйТекстОшибки%",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='(должно быть 4 числа версии, а не %1 как в %2)'"),
				МассивСловВерсии.Количество(),
				ВерсияСтрокой));
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		ВызватьИсключение Сообщение.Текст;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли