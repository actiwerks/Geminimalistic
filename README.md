# ![29](https://github.com/user-attachments/assets/9a2db911-31da-4279-9fb4-8b54a93016ef) Geminimalistic
### Artificial Intelligence in your pocket

Application implementing a AI-based chatbot, using the Gemini AI SDK from Google as its engine.

## Motivation for Geminimalistic

Wanted to explore the new Gemini AI SDK and creating an application around it was a natural way to go. Realised it might be useful to other developers (and eventually a general public, via application in AppStore, once there are more content options and refined interface) thus we made it available as a GITHub repository. Application is developed using modern Apple technologies, such as SwiftUI and is ready to use SwiftData for seamless persistence once this is needed. Feel free to reuse on "as is" (MIT style license). Let us know about your ideas/feedback etc.

## Features

The main features at the moment are: 

1. AI Chatbot (obviously)
2. Abilitity to use your own APIKey
3. Streamlined onboarding
4. Ability to delete history

## AI Chatbot

Currently the "gemini-1.5-flash" version is used, but can be swapped easily for other models

## Abilitity to use your own APIKey

This is a main "selling point" of the application to the general public. By using your own API Key (which can be obtained here: https://aistudio.google.com/app/apikey) you can drive your cost of using Gemini AI substantially compared to the plans available to general public using Google own apps (https://apps.apple.com/us/app/google/id284815942), where instead paying a flat monthly fee you can pay just for your actual usage, however the feature set is limited.

## Streamlined onboarding

Geminimalistic onboarding process shows how we think about mobile application design, embracing truly "mobile first" principle, where by dropping a traditional bag of problems we can achieve a much better experience for the user and at the same time make the application way simpler, getting rid of tons of constructs which would be costly to develop and maintain. 

### What we mean by this? 

At the onboardning time we face two tasks that need to be done:

1. Introduce the application to the user, who is seeing it for the very first time
2. Let the user obtain and enter the API Key which will be used for the Gemini engine to work

There are tons of applications having the similar task list at the onboarding, and quite often the implementation scenario is as follows:

1. Show the introduction, often in a form of a video (this part is quite commonly skipped, and the confused user is brought directly to point 2. with no clue how the application works and why there is a need for such a starting point)
2. "Login page" is shown, where user is instructed to enter the credentials required, often with other stuff where it is no clear why this is needed by the application. Quite common monstrosity is requirement "to create an user account, consisting of name and password, and the option for credentials recovery is usually presented, using bogus third party service, such as "Mail or SMS me password in case I forgot it", immediately providing a security risk (who knows how the mail or message is delivered to the user and what are vulnerabilities on the way)
3. Finally, after the login is done, the user is brought to the core of the application and is finally starting to grasp how it is working (unless they already abandoned the app, which can be more than 50% ! of cases according the research, such as: https://www.wyzowl.com/customer-onboarding-statistics)

For this scenario, application needs to add a substantial amount of code, which is driving the application architecture complexity.

Our approach is based around following principles:

1. Give user the access to actual functionality as soon as possible and provide a guidance to help explain how to use the application.
2. Only ask for the information or permissions that are needed to perform the users task and ask for them as late as possible
3. Keep the application simple and straighforward

### Geminimalistic onboarding process

At the application startup, the user is brought directly to the main screen and the application is immediately functional

![Screen 1](https://github.com/user-attachments/assets/0169517c-e6c7-434f-be29-f776426833d4)

At this point, the user learns the key concept of the app, that user query triggers a textual response from the application. There is no limit for the user to explore, but for the application to be functional, the API key is needed:

![Screen 2](https://github.com/user-attachments/assets/7f26001e-488d-4180-9aaa-07e16cd96f94)

User sees the explanation and there are more explicit instructions how to obtain the API key if the initial user attempt is not successful. Finally the user enters the API Key and application is fully functional

![Screen 3](https://github.com/user-attachments/assets/330ee210-a1b5-4347-94d1-c260b5e5771c)

After the initial setup is complete you can use it as any other AI chatbot:

![Screen 4](https://github.com/user-attachments/assets/d7f21732-c741-4d77-9dd7-399903176825)
![Screen 5](https://github.com/user-attachments/assets/05723253-c34e-4083-8b65-632f53414193)

At this point the user is fully onboarded, which means that all the information has been provided, and the user also knows how to work with the application.

### Onboarding from the Application architecture perspective

The whole onboarding process was implemented by compositing Onboarding model into a real conversational model. There is no need to separate Onboarding Intro View, Enter credentials View and Main Chat View, therefore there is no need to implement navigation between those views, there is no need to introduce some common base view functionality as it is pointless. There is no need to introduce a superfluous architecture patterns, such as ViewModel, since the conversational models are clearly separated, and testing of both business and User Interface logic can be introduced easily if this is needed.

### Onboarding from Users perspective

User is onboarded in gentle manner, by seeing the application key principles early, while they are being explained as introduced. The user is never forced into actions where the reason might be unknown. As a result, the churn rate of the onboarding process is reduced.

### Onboarding from the Application owner perspective

Overall design of the application allowed it to be both user friendly thus driving its value up (by reducing the churn rate during onboarding) while maintaining the architecture simple, driving down the development costs significantly, with both factors leading to excellent ROI. 

## Ability to delete history

Swipe any item to the left to disclose options, allowing you to delete any item in the chat history. Since Geminimalistic doesn't use Gemini chat feature, but rather replays the entire history before new question is added, it can be used to mess around with the Gemini engine, which clearly was not designed for that - try to delete some history and then point to it, and you see how the engine gets confused.

## Future development

More features, as using the long input, alternative input types, integration with App Intents are planned.
