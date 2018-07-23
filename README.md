# smARt_pet

# Inspiration
New York City is a fast-paced city where the living pressure ranks the second in America. Due to the increased depression and hidden mental disease among people, our group is inspired to create a virtual pet to interact with user, to recognize the user’s emotion and save it for future analysis to detect hidden mental disease.

# What it does
smARt Pet is a healthcare based app that built on IBM Watson’s techniques to prevent depression. The pet can communicate with users and give response based on users’ emotions. The conversation will be recognized by IBM Watson's Speech-to-Text API and be analyzed using IBM Watson's Tone Analyzer. Depending on the result, the pet would give various responses, for example, playing upbeat music through music player when the user is upset, or looking for online specialists to help them to deal with the emotions. In addition to that, the pet can also remind/alert the user about events such as exams, meetings, or real time train traffic, to try to prevent the situation that they forget something/being late which make them stressful. This app can be connected to healthcare database such as TalkSpace to predict the possibility of the user is potentially having depression.

# How we built it
We use Apple's ARKit to detect the plane field as a location to place our virtual pet. The pet can interact using voice recognition techniques of IBM Watson's Speech-to-Text API to get user's speech, and parse it into text that would be analyzed later using IBM Watson's tone analyzer API to recognize the user's emotion based on their speech. Based on the user's data, our virtual pets would suggest several choices such as, if the user is sad, then our pet would give suggestion to play some upbeat music or if the user is feeling stressed, we play some calm music, or suggest the user to call a close friend.

# Challenges we ran into:
Utilizing the ARKit to detect the plane area and positioned the pet to have perfect size. Importing the pet's 3D model from Blender into the Xcode because when we tried to import the whole animation, the Xcode wouldn't register the texture into the model and leaving our pet's transparent. Utilizing the IBM Watson's API into our code since the documentation of the swift SDK is not very well documented(older version)

# Accomplishment that we're proud of
We are able to finish our first AR program. Before this, we had no idea how to implement nor create stuff about AR/IBM Watson. We are really proud of that we can finish the majority features on time that we emphasized on helping people reducing depression caused by stress and detecting hidden mental disease.

# What we learn
Learned so much about technical stuffs (ARKit, IBM Watson, Blender) and non-technical stuffs (work management, on-time, commitment to the coding) along the way of development. We found that teamwork is very important.

# What's next for smARt Pet
Computer Vision System

Better recognition of user's emotion based on the user's face.

More accurate and precise recognition of environment area, so the pets can moved around exactly like that pet was there.

Adding animations that would respond to many situations

Getting user's data and emotion in daily basis and give it to the user's personal doctor, and later the doctor can use that to diagnose the user's mental state and condition.

Matching the data of TalkSpace, a psychological clinical working with IBM, we can detect hidden mental disease.

Implementing this kind of technology on platform such as Google Glass, to let user have more interaction with the pet, e.g. seeing the pet running around the user, or doing exercise together(running on the street with you) to reduce stress

