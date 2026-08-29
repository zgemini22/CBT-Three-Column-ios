import Foundation

/// Self-built EN/ZH string table mirroring Android's `values/strings.xml` and
/// `values-zh/strings.xml` key-for-key and word-for-word, rather than using an
/// Xcode String Catalog, so the two platforms stay in lockstep and every key is
/// visible in one place.
enum Strings {
    static func lookup(_ key: String, language: String) -> String {
        let table = language == "zh" ? zh : en
        return table[key] ?? en[key] ?? key
    }

    // MARK: - English

    static let en: [String: String] = [
        "app_name": "Three Column Method",

        // Navigation
        "nav_thought_records": "Thought Records",
        "nav_journal": "Journal",
        "about_desc": "About",
        "about_title": "About this app",
        "back_desc": "Back",
        "delete_desc": "Delete",
        "save_desc": "Save",
        "edit_desc": "Edit",
        "share_desc": "Share",

        // Thought record list
        "new_thought_record_desc": "New thought record",
        "thought_records_empty_title": "No thought records yet",
        "thought_records_empty_body": "Tap + to write down an upsetting automatic thought, spot the distortion in it, and talk back with a rational response.",
        "belief_before_after": "%1$d%% → %2$d%%",
        "group_today": "Today",
        "group_yesterday": "Yesterday",
        "group_this_week": "This Week",
        "group_this_month": "This Month",
        "search_hint": "Search",
        "search_no_results_title": "No matches",
        "search_no_results_body": "Try a different search.",

        // Thought record detail (read-only)
        "situation_display_label": "Situation",
        "distortions_none_selected": "No distortions selected",
        "belief_before_display": "Before %1$d%%",
        "belief_after_display": "After %1$d%%",

        // Thought record edit
        "new_thought_record_title": "New thought record",
        "edit_thought_record_title": "Edit thought record",
        "situation_label": "Situation (optional)",
        "situation_placeholder": "What was happening when the thought showed up?",
        "section_automatic_thought": "Automatic Thought",
        "belief_before_label": "Before",
        "section_distortions": "Cognitive Distortion(s)",
        "distortions_hint": "Tap any that apply — descriptions appear below once selected.",
        "section_rational_response": "Rational Response",
        "belief_after_label": "After",

        // Cognitive distortions
        "distortion_all_or_nothing_label": "All-or-Nothing Thinking",
        "distortion_all_or_nothing_desc": "You see things in black-and-white categories. If a situation falls short of perfect, you see it as a total failure.",
        "distortion_overgeneralization_label": "Overgeneralization",
        "distortion_overgeneralization_desc": "You see a single negative event as part of a never-ending pattern, often using words like \"always\" or \"never\".",
        "distortion_mental_filter_label": "Mental Filter",
        "distortion_mental_filter_desc": "You dwell on a single negative detail so much that your view of reality becomes darkened, like a drop of ink coloring a glass of water.",
        "distortion_discounting_positive_label": "Discounting the Positive",
        "distortion_discounting_positive_desc": "You reject positive experiences by insisting they \"don't count\" for some reason.",
        "distortion_mind_reading_label": "Jumping to Conclusions — Mind Reading",
        "distortion_mind_reading_desc": "You assume you know what someone else is thinking, without real evidence for it — and usually assume the worst.",
        "distortion_fortune_telling_label": "Jumping to Conclusions — Fortune Telling",
        "distortion_fortune_telling_desc": "You predict that things will turn out badly, and treat that prediction as if it were already an established fact.",
        "distortion_magnification_minimization_label": "Magnification or Minimization",
        "distortion_magnification_minimization_desc": "You exaggerate the importance of problems and shortcomings, or shrink the importance of your good qualities.",
        "distortion_emotional_reasoning_label": "Emotional Reasoning",
        "distortion_emotional_reasoning_desc": "You assume your negative emotions reflect the way things really are: \"I feel it, therefore it must be true.\"",
        "distortion_should_statements_label": "Should Statements",
        "distortion_should_statements_desc": "You tell yourself things should be the way you hoped, using \"should,\" \"must,\" or \"ought to,\" which leaves you feeling guilty or resentful.",
        "distortion_labeling_label": "Labeling",
        "distortion_labeling_desc": "An extreme form of overgeneralization — instead of describing an error, you attach a fixed negative label to yourself or others.",
        "distortion_personalization_label": "Personalization",
        "distortion_personalization_desc": "You see yourself as the cause of some negative external event that you weren't primarily responsible for.",

        // Journal
        "journal_topic": "Why is living in fear of opposition and criticism irrational and unnecessary?",
        "journal_topic_header": "This journal's topic",
        "journal_new_page_desc": "New journal page",
        "journal_empty_title": "No pages yet",
        "journal_empty_body": "Tap + to write your first page on this topic. Come back and add more pages whenever a new thought about it occurs to you.",
        "journal_write_placeholder": "Write your thoughts on this…",
        "journal_reorder_desc": "Drag to reorder",
        "journal_seed_entry_body": "A few starting thoughts on this topic:\n\n1. If someone reacts negatively to you, their reaction often says more about their own assumptions than about your worth.\n\n2. If a criticism is accurate, that's not a catastrophe — you can note the error, correct it, and move on without deciding it makes you a bad person.\n\n3. One mistake describes one moment, not your entire track record. You can keep changing after it.\n\n4. Other people can only judge a specific thing you did or said — no one is in a position to grade you as a whole person.\n\n5. No matter how well you do, someone will disagree with you. Disapproval doesn't spread on its own; one \"no\" isn't a verdict that follows you everywhere.\n\n6. Discomfort after criticism is normal and temporary — it fades on its own without needing to be argued away.\n\n7. Criticism mostly stings when you've quietly accepted the negative label behind it. Question the label, not just the sting.\n\n8. Disagreement is an ordinary part of any relationship — it doesn't require the relationship to end.\n\n9. Add your own idea here whenever one occurs to you — this list is yours to keep building.",

        // Language picker
        "language_section_title": "Language",
        "language_system_default": "System default",
        "language_english": "English",
        "language_chinese": "简体中文",

        // Theme picker
        "theme_section_title": "Theme",
        "theme_system_default": "System default",
        "theme_light": "Light",
        "theme_dark": "Dark",

        // Data export / import
        "data_section_title": "Data",
        "data_export_action": "Export",
        "data_import_action": "Import",
        "data_export_success": "Exported successfully.",
        "data_export_failed": "Export failed.",
        "data_import_success": "Imported %1$d thought record(s) and %2$d journal page(s).",
        "data_import_failed": "Import failed. Check the file format and try again.",
        "data_import_format_title": "Expected file format",
        "data_import_format_intro": "Import a .json file shaped like this. Use it to add many records at once — hand-write or generate the file yourself, then import it.",
        "data_import_format_note": "\"createdAt\" (milliseconds since epoch) is optional on every entry and defaults to now if left out.",
        "data_import_format_distortion_codes": "Valid \"distortions\" codes:",
        "data_import_choose_file": "Choose file",
        "cancel_desc": "Cancel",

        // Privacy
        "privacy_section_title": "Privacy",
        "privacy_lock_label": "Require unlock to open app",
        "privacy_lock_description": "Use Face ID, Touch ID, or your device passcode to open the app.",
        "privacy_lock_unavailable": "Set up Face ID, Touch ID, or a passcode on this device to use this.",
        "lock_screen_title": "Locked",
        "lock_screen_subtitle": "Unlock to see your thought records and journal.",
        "lock_screen_unlock_button": "Unlock",

        // About screen
        "about_technique_heading": "The Three-Column Technique",
        "about_technique_body": "This method, popularized by psychiatrist David Burns in \"Feeling Good: The New Mood Therapy,\" is a simple way to talk back to upsetting thoughts. Write down the automatic thought as it occurred to you, identify which distortion(s) are twisting your thinking, then write a rational response that answers the thought fairly. Rating how much you believe the thought before and after helps you see the shift.",
        "about_journal_heading": "Your journal",
        "about_journal_body": "The Journal tab is a single-topic notebook dedicated to: \u{201c}%1$@\u{201d} Add a new dated page any time a fresh thought about it occurs to you — there's no limit to how many pages you keep.",
        "about_author_label": "Author",
        "about_license_label": "License",
        "about_disclaimer": "This app is an independent, unofficial companion tool for practicing these techniques and is not affiliated with or endorsed by the book's author or publisher. It is not a substitute for professional care.",

        // Proper names / fixed data, intentionally identical in every locale
        "author_name": "Shengxing Zhang",
        "license_url": "https://ztimelightspacestar.com/apps/three-column-method/"
    ]

    // MARK: - Chinese (Simplified)

    static let zh: [String: String] = [
        "app_name": "三栏法",

        "nav_thought_records": "思维记录",
        "nav_journal": "笔记本",
        "about_desc": "关于",
        "about_title": "关于本应用",
        "back_desc": "返回",
        "delete_desc": "删除",
        "save_desc": "保存",
        "edit_desc": "编辑",
        "share_desc": "分享",

        "new_thought_record_desc": "新建思维记录",
        "thought_records_empty_title": "还没有任何记录",
        "thought_records_empty_body": "点击右下角的 + ，写下让你难受的自动化思维，找出其中的认知歪曲，再写下一个更合理的回应。",
        "belief_before_after": "%1$d%% → %2$d%%",
        "group_today": "今天",
        "group_yesterday": "昨天",
        "group_this_week": "本周",
        "group_this_month": "本月",
        "search_hint": "搜索",
        "search_no_results_title": "没有匹配结果",
        "search_no_results_body": "换个关键词试试。",

        "situation_display_label": "情境",
        "distortions_none_selected": "未选择任何认知歪曲",
        "belief_before_display": "之前 %1$d%%",
        "belief_after_display": "之后 %1$d%%",

        "new_thought_record_title": "新建思维记录",
        "edit_thought_record_title": "编辑思维记录",
        "situation_label": "情境（选填）",
        "situation_placeholder": "这个想法出现时，你正在经历什么？",
        "section_automatic_thought": "自动化思维",
        "belief_before_label": "之前",
        "section_distortions": "认知歪曲",
        "distortions_hint": "点击选中所有符合的类型，选中后下方会显示说明。",
        "section_rational_response": "合理回应",
        "belief_after_label": "之后",

        "distortion_all_or_nothing_label": "非黑即白思维",
        "distortion_all_or_nothing_desc": "你把事情简单地分成好或坏两个极端，只要结果没有达到完美，就把它看作彻底的失败。",
        "distortion_overgeneralization_label": "以偏概全",
        "distortion_overgeneralization_desc": "你把一次负面的经历当成了永远如此的规律，常常用\"总是\"\"从来\"这类词来描述。",
        "distortion_mental_filter_label": "心理过滤",
        "distortion_mental_filter_desc": "你只盯着一个负面细节不放，就像一滴墨水染黑了一整杯水，让你对整件事的看法都变得灰暗。",
        "distortion_discounting_positive_label": "否定正面评价",
        "distortion_discounting_positive_desc": "你把好的经历或成绩都说成\"不算数\"，找各种理由把它们排除在外。",
        "distortion_mind_reading_label": "妄下结论——臆测人心",
        "distortion_mind_reading_desc": "你在没有确凿依据的情况下，就认定自己知道别人在想什么，而且通常会往坏处猜测。",
        "distortion_fortune_telling_label": "妄下结论——未卜先知",
        "distortion_fortune_telling_desc": "你预测事情将会有糟糕的结局，并把这个预测当成已经发生的事实来对待。",
        "distortion_magnification_minimization_label": "放大或缩小",
        "distortion_magnification_minimization_desc": "你把问题和缺点看得过分严重，却把自己的优点和长处看得微不足道。",
        "distortion_emotional_reasoning_label": "情绪化推理",
        "distortion_emotional_reasoning_desc": "你把自己的负面情绪当成事实的证明：\"我这么难受，说明事情一定很糟\"。",
        "distortion_should_statements_label": "\"应该\"式思维",
        "distortion_should_statements_desc": "你总用\"应该\"\"必须\"\"一定要\"来要求自己或别人，一旦达不到，就陷入内疚或怨恨。",
        "distortion_labeling_label": "贴标签",
        "distortion_labeling_desc": "这是以偏概全的极端形式——你不再只是描述一次具体的失误，而是直接给自己或别人贴上一个固定的负面标签。",
        "distortion_personalization_label": "归因于己",
        "distortion_personalization_desc": "你把某些并非主要由你造成的负面事件，都归咎到自己身上。",

        "journal_topic": "为什么害怕反对和批评是非理性且没有必要的？",
        "journal_topic_header": "本笔记本的主题",
        "journal_new_page_desc": "新建一页",
        "journal_empty_title": "还没有任何一页",
        "journal_empty_body": "点击 + ，写下关于这个主题的第一页。以后每当有新的想法，随时回来再写一页。",
        "journal_write_placeholder": "写下你此刻的想法……",
        "journal_reorder_desc": "拖动排序",
        "journal_seed_entry_body": "关于这个主题，先记下几个想法作为开始：\n\n1. 如果有人对你表现出反对或不满，这更可能反映了对方自己的想法和局限，而不一定说明你做错了什么。\n\n2. 就算批评说得没错，那也不是灾难——你可以承认这个错误、把它改过来，并从中学到东西，而不必因此认定自己是个糟糕的人；毕竟没有人能做到从不犯错。\n\n3. 一次没做好，说明的只是这一件事没做好，不能代表你这个人整体的价值。你随时可以调整、可以改变、可以继续成长。\n\n4. 别人能评价的，永远只是你某一次具体的言行，没有谁有资格给你整个人打一个总分。\n\n5. 不管你表现得多好，总会有人不认同你。不认同不会像野火一样蔓延开来，一次被否定，不等于你以后永远都会被否定。\n\n6. 被反对或被批评之后感到不舒服，是很正常的反应，但这种不适感会随着时间自己慢慢过去，不需要你费力去消灭它。\n\n7. 批评之所以刺痛你，往往是因为你在心里悄悄接受了对方给你贴的那个负面标签。去质疑那个标签本身，而不是只顾着感受那份刺痛。\n\n8. 意见不合、发生争执，是任何一段关系里都会出现的正常部分，一次分歧并不会因此就让关系走到尽头。\n\n9. 以后想到新的想法，随时把它加进这一页——这份清单永远可以由你继续写下去。",

        // language_english / language_chinese intentionally identical in every locale
        "language_section_title": "语言",
        "language_system_default": "跟随系统语言",
        "language_english": "English",
        "language_chinese": "简体中文",

        "theme_section_title": "外观主题",
        "theme_system_default": "跟随系统",
        "theme_light": "浅色",
        "theme_dark": "深色",

        "data_section_title": "数据",
        "data_export_action": "导出",
        "data_import_action": "导入",
        "data_export_success": "导出成功。",
        "data_export_failed": "导出失败。",
        "data_import_success": "已导入 %1$d 条思维记录和 %2$d 篇笔记。",
        "data_import_failed": "导入失败，请检查文件格式后重试。",
        "data_import_format_title": "文件格式说明",
        "data_import_format_intro": "导入的 .json 文件需要符合以下结构。用它可以一次性批量添加多条记录——自己手写或用工具生成这个文件后再导入。",
        "data_import_format_note": "每条记录中的 \"createdAt\"（从纪元开始的毫秒数）都是可选项，省略时默认为当前时间。",
        "data_import_format_distortion_codes": "\"distortions\" 可用的代码：",
        "data_import_choose_file": "选择文件",
        "cancel_desc": "取消",

        // 隐私
        "privacy_section_title": "隐私",
        "privacy_lock_label": "打开应用时需要解锁",
        "privacy_lock_description": "使用面容 ID、指纹或设备密码打开应用。",
        "privacy_lock_unavailable": "请先在此设备上设置面容 ID、指纹或密码后再使用此功能。",
        "lock_screen_title": "已锁定",
        "lock_screen_subtitle": "解锁后即可查看你的思维记录和笔记本。",
        "lock_screen_unlock_button": "解锁",

        "about_technique_heading": "三栏认知技术",
        "about_technique_body": "这个方法由精神科医生大卫·伯恩斯（David Burns）在《伯恩斯新情绪疗法》一书中推广，是一种回应让人难受的想法的简单方式。把自动化思维原样写下来，找出其中扭曲了你思考方式的认知歪曲，再写一个更公正、更有依据的合理回应。分别给这个想法在回应前后打一个相信程度的分数，可以帮你直观地看到这个转变。",
        "about_journal_heading": "你的笔记本",
        "about_journal_body": "\u{201c}笔记本\u{201d}标签页是一本围绕单一主题展开的笔记：\u{201c}%1$@\u{201d} 以后每当你对这个主题有了新的想法，随时新建一页，页数没有限制。",
        "about_author_label": "作者",
        "about_license_label": "许可协议",
        "about_disclaimer": "本应用是一个独立、非官方的练习辅助工具，与原书作者或出版方没有任何关联，也未获得其认可。它不能替代专业的医疗或心理帮助。",

        // Proper names / fixed data, intentionally identical in every locale
        "author_name": "Shengxing Zhang",
        "license_url": "https://ztimelightspacestar.com/apps/three-column-method/"
    ]
}
