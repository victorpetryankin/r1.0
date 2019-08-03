////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивКлиентСерверПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СписокИдентификаторовИБ

// В облачный архив будут попадать резервные копии с разными идентификаторами:
//  ОсновнойИдентификатор + Суффикс, что позволит разделять копии по способу создания для дальнейшей обработки.
// Основные суффиксы: Auto (автоматические резервные копии) и Manual (ручные резервные копии).
// В этой процедуре можно добавить свои дополнительные суффиксы.
// Пример заполнения см. ОблачныйАрхивКлиентСервер.ПолучитьМассивСуффиксовИдентификаторовИБ.
//
// Параметры:
//  СтруктураИдентификаторов - Структура - Структура с ключами:
//   * Ключ - Строка - Суффикс, добавляемый к основному идентификатору ИБ (состоит из английских букв, цифр, знаков "-" и "_", в верхнем регистре);
//   * Значение - Структура - структура с ключами:
//     ** Суффикс  - Строка - суффикс, добавляемый к идентификатору ИБ для резервных копий;
//     ** Описание - Строка - текст, добавляемый к имени ИБ для резервных копий.
//
Процедура ДополнитьСтруктуруСуффиксовИдентификаторовИБ(СтруктураИдентификаторов) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти
