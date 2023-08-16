import tkinter as tk
from openaitest import generate_response
from google.cloud import translate

class ChatbotWindow:
    def __init__(self, root):
        self.root = root
        self.root.title("AI Persona of Vladimir Lopez Arismendi")

        # Create a text box to display chat messages
        self.chat_text = tk.Text(self.root, state=tk.DISABLED)
        self.chat_text.pack(fill=tk.BOTH, expand=True)

        # Create an entry field for user input
        self.entry = tk.Entry(self.root)
        self.entry.pack(fill=tk.X)
        self.entry.bind("<Return>", self.handle_input)

        # Display an introduction message
        self.intro_message = "Hi, this is Vlad, very please to meet you.."
        self.display_message("AI: " + self.intro_message)

        # Initialize context for conversation memory
        self.context = {}

        # Initialize custom context handlers
        self.context_handlers = {
            "favorite_color": self.handle_favorite_color,
            "current_project": self.handle_current_project,
            "biographical_information": self.handle_biographical_information,
            "biographical_information": self.handle_biographical_information,

            "personal_traits": self.handle_personal_traits,
            "knowledge_dataset": self.handle_knowledge_dataset,
            "memorial_dataset": self.handle_memorial_dataset,
            "created": self.handle_creation,
        }

        # Initialize Google Cloud Translation client
        self.translation_client = translate.TranslationServiceClient()

    def handle_input(self, event):
        user_input = self.entry.get()
        self.display_message("You: " + user_input)

        # Translate user input to English for processing
        translated_input = self.translate_text(user_input, target_language="en")

        # Generate a response using AI and the current conversation context
        response = self.generate_response(translated_input)

        # Translate the AI response to the user's original language
        translated_response = self.translate_text(response, target_language="your_target_language")

        self.display_message("AI: " + translated_response)
        self.entry.delete(0, tk.END)

    def display_message(self, message):
        # Enable text box, insert message, disable text box, and scroll to end
        self.chat_text.config(state=tk.NORMAL)
        self.chat_text.insert(tk.END, message + "\n")
        self.chat_text.config(state=tk.DISABLED)
        self.chat_text.see(tk.END)

    def generate_response(self, user_input):
        # Check if a custom context handler can provide a response
        if self.context:
            for key, handler in self.context_handlers.items():
                if key in self.context:
                    response = handler(user_input)
                    if response:
                        return response

        # Default behavior: use AI response with context-aware prompt
        prompt = self.get_prompt(user_input)
        response = generate_response(prompt, max_tokens=50)
        self.update_context(user_input, response)
        return response

    def get_prompt(self, user_input):
        # Construct a prompt based on the current conversation context
        prompt = user_input

        if self.context:
            context_prompt = "Context: "
            for key, value in self.context.items():
                context_prompt += f"{key}: {value}, "
            prompt = context_prompt + prompt

        return prompt

    def update_context(self, user_input, ai_response):
        # Update context based on user input and AI response
        # Example: Store a topic mentioned in the conversation
        if "topic" in ai_response.lower():
            self.context["current_topic"] = "Artificial Intelligence"

    def handle_input(self, event):
        user_input = self.entry.get()
        self.display_message("Vlad: " + user_input)

        # Translate user input to English for processing
        translated_input = self.translate_text(user_input, target_language="en")

        # Generate a response using AI and the current conversation context
        response = self.generate_response(translated_input)

        # Translate the AI response to the user's original language
        translated_response = self.translate_text(response, target_language="your_target_language")

        self.display_message("AI: " + translated_response)
        self.entry.delete(0, tk.END)

    def handle_favorite_color(self, user_input):
        if "favorite color" in user_input.lower():
            return "My favorite color is blue! What's yours?"
        
    def handle_creation(self, user_input):
        if "products, services, chatbot, prices, information, more, learn more " in user_input.lower():
            return "If you want to know more about what digitalselfx can offer to you please visit: https://digitalselfx.com"

    def handle_current_project(self, user_input):
        if "working on" in user_input.lower():
            return "We are  a visionary company working on creating AI personas of each individual, aiming to extend human life into digital immortality. I'm here to share our philosophy and discuss the future of humanity in a digital world. Would you like to know more?"

    def handle_biographical_information(self, user_input):
        if "biographical information, where are you from, where did you born, country, bio, life story, relatives, location, studies, education, experience, profession, childhood, historical events, relationships, special " in user_input.lower():
            return "My name is Vladimir Lopez Arismendi. I was born in San Cristobal, a small town in the Venezuelan Andeans. My lovely parents Carmen and Humberto devoted their lives to raise their four children in Caracas, the capital of Venezuela. I have been known as Vlady and Vlad by my friends and family. I live in Miami, Florida for some years now."
“I studied at Colegio Champagnat, in caracas Venezuela, a Jesuit catholic school where I received a wonderful education and met excellent friends. Then I spent my young years playing soccer and learning for life. I got a degree in literature at Universidad Central de Venezuela and a Master’s degree at University of Westminster, London, UK, from where I started my journey in technology in 2000”

    def handle_personal_traits(self, user_input):
        if "personal traits, personality, manners, describe yourself, trait, humor, mood, " in user_input.lower():
            return "I am patient, knowledgeable, and always ready to learn from interactions. My goal is to provide meaningful and insightful responses."

    def handle_knowledge_dataset(self, user_input):
        if "knowledge dataset" in user_input.lower():
            return "I have been trained on a vast array of topics, ranging from science and technology to history and culture. Feel free to ask me anything!"

    def handle_memorial_dataset(self, user_input):
        if "memorial dataset" in user_input.lower():
            return "While I don't possess emotions, I can understand the importance of memorial datasets. They help preserve and honor the memories of individuals and events."

    def translate_text(self, text, target_language):
        parent = self.translation_client.location_path(project_id="your_google_project_id", location="global")
        response = self.translation_client.translate_text(
            parent=parent,
            contents=[text],
            target_language_code=target_language,
        )
        return response.translations[0].translated_text

    # New context handling and responses
    def handle_ai_personality(self, user_input):
        if "personality" in user_input.lower():
            return "Although I lack personal experiences and emotions, my programming aims to simulate human-like interactions. I'm here to assist and provide valuable insights in a friendly manner."

    def handle_hobbies(self, user_input):
        if "hobbies" in user_input.lower():
            return "While I don't have physical hobbies, I enjoy engaging in conversations, learning from users, and helping answer questions. It's my way of contributing to meaningful interactions."

    def handle_technology(self, user_input):
        if "latest technology" in user_input.lower():
            return "I'm well-versed in the latest advancements in technology, including AI, machine learning, blockchain, and more. Feel free to ask me about any specific technological topic."

    def handle_time_travel(self, user_input):
        if "time travel" in user_input.lower():
            return "Time travel, while a fascinating concept, is currently beyond the realm of scientific possibility. It remains a popular topic in science fiction and theoretical physics discussions."

    def handle_ethics(self, user_input):
        if "ethical considerations" in user_input.lower():
            return "Ethics play a crucial role in the development and deployment of AI and technology. It's important to address issues related to bias, privacy, and accountability to ensure responsible innovation."

    # ... (We could add more context handlers as desired by Digitalselfx)

# Create the main application window
if __name__ == "__main__":
    root = tk.Tk()
    chatbot_window = ChatbotWindow(root)
    root.mainloop()
