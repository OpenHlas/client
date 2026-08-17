namespace App.Utils {
    private class EmojiOption : Object {
        public string value { get; private set; }
        public string category_id { get; private set; }
        public Gee.ArrayList<string> aliases { get; private set; }

        public EmojiOption (string category_id, string value) {
            this.category_id = category_id;
            this.value = value;
            aliases = new Gee.ArrayList<string> ();
        }
    }

    public class EmojiCategory : Object {
        public string id { get; private set; }
        public string title { get; private set; }
        public Gee.ArrayList<string> emojis { get; private set; }

        public EmojiCategory (string id, string title) {
            this.id = id;
            this.title = title;
            emojis = new Gee.ArrayList<string> ();
        }
    }

    public class Emoji : Object {
        private Gee.ArrayList<EmojiOption> options;

        public Emoji () {
            options = new Gee.ArrayList<EmojiOption> ();

            add_option ("Faces", "😍", { ":heart_eyes:" });
            add_option ("Faces", "😎", { ":sunglasses:" });
            add_option ("Reactions", "👍", { ":thumbsup:", ":+1:" });
            add_option ("Reactions", "👎", { ":thumbsdown:", ":-1:" });
            add_option ("Faces", "🤔", { ":thinking:" });
            add_option ("Faces", "😀", { ":grinning:" });
            add_option ("Faces", "😄", { ":smile:", ":-D", ":D" });
            add_option ("Activities", "🚀", { ":rocket:" });
            add_option ("Reactions", "🎉", { ":tada:" });
            add_option ("Reactions", "❤️", { ":heart:", "<3" });
            add_option ("Reactions", "🔥", { ":fire:" });
            add_option ("Gestures", "👋", { ":wave:" });
            add_option ("Faces", "😭", { ":sob:" });
            add_option ("Faces", "😂", { ":joy:" });
            add_option ("Faces", "😉", { ":wink:", ";-)", ";)" });
            add_option ("Faces", "🙂", { ":-)", ":)" });
            add_option ("Faces", "🙁", { ":-(", ":(" });
            add_option ("Faces", "😆", { "xD", "XD" });
            add_option ("Faces", "😛", { ":-P", ":P" });
            add_option ("Faces", "🤣", { ":rofl:" });
            add_option ("Faces", "😢", { ":cry:" });
            add_option ("Faces", "😡", { ":angry:" });
            add_option ("Faces", "😱", { ":scream:" });
            add_option ("Faces", "🤗", { ":hugs:" });
            add_option ("Faces", "🤩", { ":star_struck:" });
            add_option ("Gestures", "👏", { ":clap:" });
            add_option ("Gestures", "🙏", { ":pray:" });
            add_option ("Gestures", "💪", { ":muscle:" });
            add_option ("Reactions", "✅", { ":white_check_mark:", ":check:" });
            add_option ("Reactions", "❌", { ":x:", ":cross_mark:" });
            add_option ("Faces", "👀", { ":eyes:" });
            add_option ("Reactions", "💯", { ":100:" });
            add_option ("Reactions", "✨", { ":sparkles:" });
            add_option ("Faces", "😴", { ":sleeping:" });
            add_option ("Faces", "🤯", { ":exploding_head:" });
            add_option ("Faces", "🤢", { ":nauseated_face:" });
            add_option ("Faces", "🤮", { ":vomiting_face:" });
            add_option ("Gestures", "🤝", { ":handshake:" });
            add_option ("Gestures", "👌", { ":ok_hand:" });
            add_option ("Gestures", "✌️", { ":v:" });
            add_option ("Gestures", "🤞", { ":crossed_fingers:" });
            add_option ("Activities", "🎊", { ":confetti_ball:" });
            add_option ("Objects", "🎁", { ":gift:" });
            add_option ("Activities", "🏆", { ":trophy:" });
            add_option ("Objects", "💡", { ":bulb:" });
            add_option ("Objects", "⚡", { ":zap:" });
            add_option ("Nature", "🌟", { ":star2:" });
            add_option ("Nature", "🌈", { ":rainbow:" });
            add_option ("Nature", "☀️", { ":sunny:" });
            add_option ("Nature", "🌙", { ":crescent_moon:" });
            add_option ("Nature", "🐶", { ":dog:" });
            add_option ("Nature", "🐱", { ":cat:" });
            add_option ("Nature", "🦊", { ":fox_face:" });
            add_option ("Nature", "🐼", { ":panda_face:" });
            add_option ("Food", "🍕", { ":pizza:" });
            add_option ("Food", "🍔", { ":hamburger:" });
            add_option ("Food", "☕", { ":coffee:" });
            add_option ("Food", "🍺", { ":beer:" });
            add_option ("Activities", "🎵", { ":musical_note:" });
            add_option ("Activities", "🎶", { ":notes:" });
            add_option ("Activities", "⚽", { ":soccer:" });
            add_option ("Activities", "🎮", { ":video_game:" });
            add_option ("Faces", "😇", { ":innocent:" });
            add_option ("Faces", "🤓", { ":nerd_face:" });
            add_option ("Faces", "😏", { ":smirk:" });
            add_option ("Faces", "😮", { ":open_mouth:" });
            add_option ("Faces", "😬", { ":grimacing:" });
            add_option ("Faces", "🙄", { ":roll_eyes:" });
            add_option ("Faces", "😤", { ":triumph:" });
            add_option ("Reactions", "💚", { ":green_heart:" });
            add_option ("Reactions", "💙", { ":blue_heart:" });
            add_option ("Reactions", "💜", { ":purple_heart:" });
            add_option ("Reactions", "💔", { ":broken_heart:" });
            add_option ("Reactions", "🙌", { ":raised_hands:" });
            add_option ("Reactions", "🎯", { ":dart:" });
            add_option ("Gestures", "☝️", { ":point_up:" });
            add_option ("Gestures", "👇", { ":point_down:" });
            add_option ("Gestures", "👉", { ":point_right:" });
            add_option ("Gestures", "👈", { ":point_left:" });
            add_option ("Gestures", "🤘", { ":the_horns:" });
            add_option ("Objects", "📌", { ":pushpin:" });
            add_option ("Objects", "📎", { ":paperclip:" });
            add_option ("Objects", "🔔", { ":bell:" });
            add_option ("Objects", "🔒", { ":lock:" });
            add_option ("Objects", "🔑", { ":key:" });
            add_option ("Nature", "🌲", { ":evergreen_tree:" });
            add_option ("Nature", "🌸", { ":cherry_blossom:" });
            add_option ("Nature", "🌊", { ":ocean:" });
            add_option ("Food", "🍎", { ":apple:" });
            add_option ("Food", "🍉", { ":watermelon:" });
            add_option ("Food", "🍩", { ":doughnut:" });
            add_option ("Food", "🍰", { ":cake:" });
            add_option ("Food", "🍿", { ":popcorn:" });
            add_option ("Activities", "🎸", { ":guitar:" });
            add_option ("Activities", "🏀", { ":basketball:" });
            add_option ("Activities", "🏈", { ":football:" });
            add_option ("Activities", "🚗", { ":car:" });
            add_option ("Activities", "✈️", { ":airplane:" });
            add_option ("Faces", "😅", { ":sweat_smile:" });
            add_option ("Faces", "😌", { ":relieved:" });
            add_option ("Faces", "🤫", { ":shushing_face:" });
            add_option ("Faces", "🤭", { ":hand_over_mouth:" });
            add_option ("Faces", "🤡", { ":clown_face:" });
            add_option ("Faces", "👻", { ":ghost:" });
            add_option ("Faces", "💀", { ":skull:" });
            add_option ("Reactions", "🖤", { ":black_heart:" });
            add_option ("Reactions", "🧡", { ":orange_heart:" });
            add_option ("Reactions", "💛", { ":yellow_heart:" });
            add_option ("Reactions", "💖", { ":sparkling_heart:" });
            add_option ("Reactions", "💥", { ":boom:", ":collision:" });
            add_option ("Reactions", "❗", { ":exclamation:", ":heavy_exclamation_mark:" });
            add_option ("Reactions", "❓", { ":question:" });
            add_option ("Gestures", "🤟", { ":love_you_gesture:" });
            add_option ("Gestures", "🫶", { ":heart_hands:" });
            add_option ("Objects", "📣", { ":mega:" });
            add_option ("Objects", "📢", { ":loudspeaker:" });
            add_option ("Objects", "💬", { ":speech_balloon:" });
            add_option ("Objects", "💤", { ":zzz:" });
            add_option ("Objects", "🔍", { ":mag:" });
            add_option ("Objects", "📅", { ":date:" });
            add_option ("Nature", "🌻", { ":sunflower:" });
            add_option ("Nature", "🌴", { ":palm_tree:" });
            add_option ("Nature", "❄️", { ":snowflake:" });
            add_option ("Nature", "☁️", { ":cloud:" });
            add_option ("Food", "🍓", { ":strawberry:" });
            add_option ("Food", "🍌", { ":banana:" });
            add_option ("Food", "🌮", { ":taco:" });
            add_option ("Food", "🍪", { ":cookie:" });
            add_option ("Food", "🥳", { ":partying_face:" });
            add_option ("Activities", "🎤", { ":microphone:" });
            add_option ("Activities", "🎧", { ":headphones:" });
            add_option ("Activities", "🎲", { ":game_die:" });
            add_option ("Faces", "😓", { ":cold_sweat:" });
            add_option ("Faces", "😔", { ":pensive:" });
            add_option ("Faces", "😞", { ":disappointed:" });
            add_option ("Faces", "😖", { ":confounded:" });
            add_option ("Faces", "😫", { ":tired_face:" });
            add_option ("Faces", "😳", { ":flushed:" });
            add_option ("Faces", "🤠", { ":cowboy_hat_face:" });
            add_option ("Faces", "🤖", { ":robot:" });
            add_option ("Gestures", "👊", { ":facepunch:", ":fist:" });
            add_option ("Gestures", "✊", { ":fist_raised:" });
            add_option ("Gestures", "🤲", { ":palms_up_together:" });
            add_option ("Gestures", "🙇", { ":bow:" });
            add_option ("Gestures", "💁", { ":person_tipping_hand:" });
            add_option ("Nature", "🐭", { ":mouse:" });
            add_option ("Nature", "🐰", { ":rabbit:" });
            add_option ("Nature", "🐸", { ":frog:" });
            add_option ("Nature", "🐵", { ":monkey_face:" });
            add_option ("Nature", "🦄", { ":unicorn:" });
            add_option ("Nature", "🐝", { ":bee:", ":honeybee:" });
            add_option ("Nature", "🌍", { ":earth_americas:" });
            add_option ("Nature", "🌧️", { ":rain_cloud:" });
            add_option ("Food", "🍇", { ":grapes:" });
            add_option ("Food", "🍒", { ":cherries:" });
            add_option ("Food", "🥕", { ":carrot:" });
            add_option ("Food", "🌽", { ":corn:" });
            add_option ("Food", "🍜", { ":ramen:" });
            add_option ("Food", "🍣", { ":sushi:" });
            add_option ("Food", "🍦", { ":icecream:" });
            add_option ("Food", "🍫", { ":chocolate_bar:" });
            add_option ("Activities", "🎬", { ":clapper:" });
            add_option ("Activities", "📚", { ":books:" });
            add_option ("Activities", "✏️", { ":pencil2:" });
            add_option ("Activities", "🏓", { ":ping_pong:" });
            add_option ("Activities", "🎳", { ":bowling:" });
            add_option ("Activities", "🏊", { ":swimmer:" });
            add_option ("Objects", "📱", { ":iphone:" });
            add_option ("Objects", "💻", { ":computer:" });
            add_option ("Objects", "⌨️", { ":keyboard:" });
            add_option ("Objects", "🖱️", { ":computer_mouse:" });
            add_option ("Objects", "📷", { ":camera:" });
            add_option ("Objects", "🔦", { ":flashlight:" });
            add_option ("Objects", "🧰", { ":toolbox:" });
            add_option ("Objects", "📝", { ":memo:" });
            add_option ("Nature", "🌳", { ":deciduous_tree:" });
            add_option ("Nature", "🌵", { ":cactus:" });
            add_option ("Nature", "🍀", { ":four_leaf_clover:" });
            add_option ("Nature", "🌺", { ":hibiscus:" });
            add_option ("Nature", "🌪️", { ":cloud_with_tornado:" });
            add_option ("Nature", "🌋", { ":volcano:" });
            add_option ("Food", "🥐", { ":croissant:" });
            add_option ("Food", "🥨", { ":pretzel:" });
            add_option ("Food", "🌭", { ":hotdog:" });
            add_option ("Food", "🥪", { ":sandwich:" });
            add_option ("Food", "🍟", { ":fries:" });
            add_option ("Food", "🍭", { ":lollipop:" });
            add_option ("Food", "🍮", { ":custard:" });
            add_option ("Food", "🥤", { ":cup_with_straw:" });
            add_option ("Activities", "🎨", { ":art:" });
            add_option ("Activities", "🧩", { ":jigsaw:" });
            add_option ("Activities", "🏹", { ":bow_and_arrow:" });
            add_option ("Activities", "⛳", { ":golf:" });
            add_option ("Activities", "🎿", { ":ski:" });
            add_option ("Activities", "🏄", { ":surfer:" });
            add_option ("Activities", "🚴", { ":bicyclist:" });
            add_option ("Activities", "🧘", { ":person_in_lotus_position:" });
        }

        public string replace_shortcodes (string content) {
            var replaced_content = content.dup ();

            foreach (var option in options) {
                foreach (var alias in option.aliases) {
                    replaced_content = replaced_content.replace (alias, option.value);
                }
            }
            return replaced_content;
        }

        public Gee.ArrayList<string> get_picker_emojis () {
            var emojis = new Gee.ArrayList<string> ();
            foreach (var option in options) {
                emojis.add (option.value);
            }
            return emojis;
        }

        public Gee.ArrayList<EmojiCategory> get_picker_categories () {
            var categories = new Gee.ArrayList<EmojiCategory> ();
            add_category (categories, "faces", _("Faces"));
            add_category (categories, "reactions", _("Reactions"));
            add_category (categories, "gestures", _("Gestures"));
            add_category (categories, "objects", _("Objects"));
            add_category (categories, "nature", _("Nature"));
            add_category (categories, "food", _("Food"));
            add_category (categories, "activities", _("Activities"));

            foreach (var option in options) {
                foreach (var category in categories) {
                    if (category.id == option.category_id) {
                        category.emojis.add (option.value);
                        break;
                    }
                }
            }
            return categories;
        }

        private void add_category (Gee.ArrayList<EmojiCategory> categories, string id, string title) {
            categories.add (new EmojiCategory (id, title));
        }

        private void add_option (string category, string value, string[] aliases) {
            var option = new EmojiOption (normalize_category_id (category), value);
            foreach (var alias in aliases) {
                option.aliases.add (alias);
            }
            options.add (option);
        }

        private string normalize_category_id (string category) {
            switch (category) {
                case "Faces":
                    return "faces";
                case "Reactions":
                    return "reactions";
                case "Gestures":
                    return "gestures";
                case "Objects":
                    return "objects";
                case "Nature":
                    return "nature";
                case "Food":
                    return "food";
                case "Activities":
                    return "activities";
                default:
                    return category;
            }
        }
    }
}
