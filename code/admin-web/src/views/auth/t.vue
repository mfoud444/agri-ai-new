<script setup lang='ts'>
import { MainHeader } from '@/components/common';
import { Footer } from '@/components/common';
import { SvgIcon } from '@/components/common';
import { t } from '@/locales';
</script>

<template>
    <div class="container pb-1">
        <MainHeader />
        <div class="flex flex-col justify-center items-center px-6 text-base font-bold">
            <section class="intro-section">
                <h2 class="text-xl font-bold mb-4">{{ t('termsOfUse.introduction') }}</h2>
                <p>
                    The following terms are a legal agreement between RandAI ("RandAI" or "we" or "us") and you ("you")
                    regarding the services provided to you through the website randai.web.app. Please read carefully the
                    following terms and conditions before using our services. By clicking "I accept" when completing the
                    registration process or using our services, YOU DECLARE YOUR ACCEPTANCE AND AGREE TO ALL TERMS AND
                    CONDITIONS OF THIS AGREEMENT, and that you are authorized to act on behalf of the owner of this account.
                    If you do not agree with them, you should not use our services.
                </p>
                <p>
                    We reserve the right, at our sole discretion, to change, add, or delete portions of these Terms of Use
                    at any time without further notice.
                </p>
            </section>

            <!-- Services Section -->
            <section class="services-section">
                <h2 class="text-xl font-bold mb-4">Services</h2>
                <p>
                    You must fill in the registration form on page "Register" to use the services. You must provide truthful
                    and accurate information about yourself as requested in the registration form. As part of the
                    registration process, you must specify your email address and a password for your account. You are
                    responsible for maintaining the security of your account, passwords, and for all the use of the account
                    that belongs to you. RandAI reserves the right to refuse to register a user or cancel an account if
                    appropriate.
                </p>
                <p>
                    Part of the services we provide are free, while others are provided on a monthly (or annual) fee. The
                    monthly fee paid by you to us will vary depending on the services that you ask us to provide to you. You
                    can ask us and agree to upgrade or downgrade the services we provide, and the monthly fee will be
                    amended accordingly.
                </p>
                <p>
                    RandAI uses every effort to ensure that access to our services is available to you. You agree, however,
                    that there may be times, scheduled and unscheduled, where services will be unavailable. We will notify
                    you about the planned operations and the unavailability of the service. Despite all efforts, RandAI is
                    not responsible for any loss of service which occurs as a result of or non-availability of the service.
                </p>
                <p>
                    RandAI makes no guarantee that all the chat texts will be delivered without any problem to all visitors
                    of your website because of the variety of browsers and their versions. Also in some, mainly old,
                    browsers it is not possible to display the chat window or it may not be displayed correctly. In any
                    case, we are not liable if the chat window is not displayed correctly or the installation of the chat
                    windows on your website results in the incorrect display of the website. The user is responsible and
                    should check that the website appears and functions without any problem after the installation of the
                    service.
                </p>
                <p>
                    RandAI employs the OpenAI API to create AI chatbots that enhance your live chat experience. These
                    chatbots utilize state-of-the-art natural language processing (NLP) technology to understand and respond
                    to written language in a manner similar to human conversation. However, it is important to note that AI
                    chatbots, while advanced, are not infallible and may occasionally provide incorrect or inaccurate
                    information. We encourage users to review their chat history for any potential inaccuracies and take
                    appropriate measures to address them, such as creating a new question-answer (QA) pair that provides a
                    more accurate response.
                </p>
                <p>
                    Please be aware that RandAI is not responsible for any incorrect or inaccurate information provided by
                    the AI chatbots, nor for any consequences that may arise from such information. Users are solely
                    responsible for verifying the accuracy of any information received from the chatbots and for taking
                    appropriate actions based on that information. We urge users to exercise caution and discretion when
                    relying on information provided by the AI chatbots.
                </p>
            </section>

            <!-- LIMITATIONS AND RESTRICTIONS Section -->
            <section class="limitations-section">
                <h2 class="text-xl font-bold mb-4">LIMITATIONS AND RESTRICTIONS</h2>
                <p>
                    You agree not to use the services for any use or purpose that:
                </p>
                <ul class="list-disc ml-6">
                    <li>Breach any applicable local, state or federal laws</li>
                    <li>Is defamatory, blasphemous, pornographic, incites hatred, crime, terrorism or any other offense</li>
                    <li>Is misleading, for example, you present yourself like you're someone else</li>
                    <li>For any use that violates the intellectual property rights of others</li>
                </ul>
                <p>
                    You are not permitted to use our AI chatbot for the following purposes:
                </p>
                <ul class="list-disc ml-6">
                    <li>Illegal activities or any actions that exploit or harm children</li>
                    <li>Generating hateful, harassing, or violent content that targets individuals or groups based on their
                        identity, or that promotes violence</li>
                    <li>Creating malware or code designed to disrupt or damage computer systems</li>
                    <li>Activities that carry a high risk of physical harm, including weapons development or management of
                        critical infrastructure</li>
                    <li>Generating content that promotes self-harm, eating disorders, or acts of violence</li>
                    <li>Activities that carry a high risk of economic harm, such as multi-level marketing, or making
                        automated eligibility determinations for credit, or public assistance</li>
                    <li>Fraudulent or deceptive activities, including scams, fake reviews or disinformation</li>
                    <li>Producing adult content including content meant to arouse sexual excitement (excluding sex education
                        and wellness)</li>
                    <li>Political campaigning or lobbying, including generating campaign materials or building products for
                        political purposes</li>
                    <li>Violating people's privacy, including tracking individuals without consent or unlawfully collecting
                        or disclosing personal information</li>
                    <li>Engaging in the unauthorized practice of law, providing tailored legal or financial advice without
                        qualified review, or offering medical diagnoses or treatment instructions</li>
                </ul>
                <p>
                    Please note that our AI chatbot is not designed to provide legal, financial, or medical advice, and
                    should not be used for these purposes. We urge users to exercise caution and ensure that their use of
                    our AI chatbot complies with all applicable laws and regulations.
                </p>
                <p>
                    We have every right to revise the policies of using the service, including the maximum number of
                    conversations that a user can have per month (free package) and maximum days the dialogs are saved.
                    Also, the prices of the packages may change at any time. The prices listed on the relevant webpage of
                    the website are always applicable, and customers who pay for our services will be notified in time for
                    the price change by email.
                </p>
                <p>
                    By subscribing to a paid plan (by credit card or PayPal account): (i) you declare that you are
                    authorized to use this account / card. (ii) you give authorization to RandAI to debit the account / card
                    for all charges associated with your account on a monthly, half-year, or annual fee until you cancel
                    your subscription.
                </p>
                <p>
                    The corresponding costs will be charged even if your account is active but not in use. If you want to
                    stop being charged, you are responsible for canceling your subscription before the next defined payment.
                    If you cancel your subscription, you will be on your paid plan up to the date you have paid for. After
                    that, you will be degraded to the free plan.
                </p>
                <p>
                    Unauthorized use of services and / or reselling the services without the prior written consent of RandAI
                    is expressly prohibited.
                </p>
            </section>


            <section class="refund-policy-section">
                <h2 class="text-xl font-bold mb-4">REFUND POLICY</h2>
                <p>
                    We encourage our users to try our service for free before they pay for a plan. However you can easily
                    cancel your subscription at any time from the operator console. There are no cancellation fees, though
                    no refunds are provided for prorated periods. If you cancel your subscription, your plan will be active
                    up to the date you have paid for. After that you will degraded to the free plan.
                </p>

            </section>

            <section class="third-parties-section">
                <h2 class="text-xl font-bold mb-4">THIRD PARTIES</h2>
                <p>
                    If you use RandAI account of a Third Party or a third party uses the service through your account, you
                    declare and guarantee that (i) you are authorized to act on behalf of the third party and that third
                    party is bound by this agreement and (ii) you will not give or share customer information with third
                    parties.
                </p>

            </section>

            <section class="proprietary-rights-section">
                <h2 class="text-xl font-bold mb-4">PROPRIETARY RIGHTS</h2>
                <p>
                    This agreement is relating to the services provided by RandAI and you are not given any permission for
                    any software. You may not in any way, directly or indirectly: reverse engineering, disassemble or
                    attempt to discover the source code, algorithms, or data related to the services of RandAI. You should
                    not remove or modify any information of the services, and to create derivative work based on RandAI. The
                    services that you can access from your account should be used exclusively by your business and you have
                    not the right to share or resell the services in any way in favor of third parties.
                </p>
                <p>
                    The RandAI, RandAI.com and associated logos, trademarks, product names and trade names associated with
                    RandAI are owned by RandAI. You cannot use any of our labels, or product names without our express
                    written consent.
                </p>
                <!-- ... (continue with the rest of the proprietary rights content) -->
            </section>


        </div>
        <Footer />
    </div>
</template>





<!-- split this text in tags and add css use tailwind classes 
<script setup lang='ts'>
import { MainHeader } from '@/components/common';
import { Footer } from '@/components/common';
</script>

<template>
    <div class="container pb-1">
    <MainHeader/>
    <div class="flex justify-center items-center px-6 text-base font-bold">
Introduction
The following terms are a legal agreement between RandAI ("RandAI" or "we" or "us") and you ("you") regarding the services provided to you through the website randai.web.app. Please read carefully the following terms and conditions before using our services. By clicking "I accept" when completing the registration process or using our services, YOU DECLARE YOUR ACCEPTANCE AND AGREE TO ALL TERMS AND CONDITIONS OF THIS AGREEMENT, and that you are authorized to act on behalf of the owner of this account. If you do not agree with them, you should not use our services.

We reserve the right, at our sole discretion, to change, add, or delete portions of these Terms of Use at any time without further notice.

Services
You must fill in the registration form on page "Register" to use the services. You must provide truthful and accurate information about yourself as requested in the registration form. As part of the registration process, you must specify your email address and a password for your account. You are responsible for maintaining the security of your account, passwords, and for all the use of the account that belongs to you. RandAI reserves the right to refuse to register a user or cancel an account if appropriate.

Part of the services we provide are free, while others are provided on a monthly (or annual) fee. The monthly fee paid by you to us will vary depending on the services that you ask us to provide to you. You can ask us and agree to upgrade or downgrade the services we provide and the monthly fee will be amended accordingly.

RandAI uses every effort to ensure that access to our services is available to you. You agree, however, that there may be times, scheduled and unscheduled, where services will be unavailable . We will notify you about the planned operations and the unavailability of the service. Despite all efforts, RandAI is not responsible for any loss of service which occurs as a result of or non-availability of the service.

RandAI makes no guarantee that all the chat texts will be delivered without any problem to all visitors of your website because of the variety of browsers and their versions. Also in some, mainly old, browsers it is not possible to display the chat window or it may not be displayed correctly. In any case we are not liable if the chat window is not displayed correctly or the installation of the chat windows on your website, results in the incorrect display of the website. The user is responsible and should check that the website appears and functions without any problem after the installation of the service.

RandAI employs the OpenAI API to create AI chatbots that enhance your live chat experience. These chatbots utilize state-of-the-art natural language processing (NLP) technology to understand and respond to written language in a manner similar to human conversation. However, it is important to note that AI chatbots, while advanced, are not infallible and may occasionally provide incorrect or inaccurate information. We encourage users to review their chat history for any potential inaccuracies and take appropriate measures to address them, such as creating a new question-answer (QA) pair that provides a more accurate response.

Please be aware that RandAI is not responsible for any incorrect or inaccurate information provided by the AI chatbots, nor for any consequences that may arise from such information. Users are solely responsible for verifying the accuracy of any information received from the chatbots and for taking appropriate actions based on that information. We urge users to exercise caution and discretion when relying on information provided by the AI chatbots.

LIMITATIONS AND RESTRICTIONS
You agree not to use the services for any use or purpose that:

breach any applicable local, state or federal laws
is defamatory, blasphemous, pornographic, incites hatred, crime, terrorism or any other offense
is misleading, for example, you present yourself like you're someone else
for any use that violates the intellectual property rights of others

You are not permitted to use our AI chatbot for the following purposes:
Illegal activities or any actions that exploit or harm children.
Generating hateful, harassing, or violent content that targets individuals or groups based on their identity, or that promotes violence.
Creating malware or code designed to disrupt or damage computer systems.
Activities that carry a high risk of physical harm, including weapons development or management of critical infrastructure.
Generating content that promotes self-harm, eating disorders, or acts of violence.
Activities that carry a high risk of economic harm, such as multi-level marketing, or making automated eligibility determinations for credit, or public assistance.
Fraudulent or deceptive activities, including scams, fake reviews or disinformation.
Producing adult content including content meant to arouse sexual excitement (excluding sex education and wellness).
Political campaigning or lobbying, including generating campaign materials or building products for political purposes.
Violating people's privacy, including tracking individuals without consent or unlawfully collecting or disclosing personal information.
Engaging in the unauthorized practice of law, providing tailored legal or financial advice without qualified review, or offering medical diagnoses or treatment instructions.
Please note that our AI chatbot is not designed to provide legal, financial, or medical advice, and should not be used for these purposes. We urge users to exercise caution and ensure that their use of our AI chatbot complies with all applicable laws and regulations.
We have every right to revise the policies of using the service, including the maximum number of conversations that a user can have per month (free package) and maximum days the dialogs are saved. Also the prices of the packages may change at any time. The prices listed in the relevant webpage of the website are always applicable and customers who pay for our services will be notified in time for the price change by email.

By subscribing to a paid plan (by credit card or paypal account): (i) you declare that you are authorized to use this account / card. (ii) you give authorization to RandAI to debit the account / card for all charges associated with your account on a monthly, half year or annual fee until you cancel your subscription.

The corresponding costs will be charged even if your account is active but not in use. If you want to stop being charged, you are responsible for canceling your subscription before the next defined payment. If you cancel your subscription you will be on your paid plan up to the date you have paid for. After that you will be degraded to the free plan.

Unauthorized use of services and / or reselling the services without the prior written consent of RandAI, is expressly prohibited.

REFUND POLICY
We encourage our users to try our service for free before they pay for a plan. However you can easily cancel your subscription at any time from the operator console. There are no cancellation fees, though no refunds are provided for prorated periods. If you cancel your subscription, your plan will be active up to the date you have paid for. After that you will degraded to the free plan.

THIRD PARTIES
If you use RandAI account of a Third Party or a third party uses the service through your account, you delcare and guarantee that (i) you are authorized to act on behalf of the third party and that third party is bound by this agreement and (ii) you will not give or share customer information with third parties.

PROPRIETARY RIGHTS
This agreement is relating to the services provided by RandAI and you are not given any permission for any software. You may not in any way, directly or indirectly: reverse engineering, disassemble or attempt to discover the source code, algorithms, or data related to the services of RandAI. You should not remove or modify any information of the services, and to create derivative work based on RandAI. The services that you can access from your account should be used exclusively by your business and you have not the right to share or resell the services in any way in favor of third parties.

The RandAI, RandAI.com and associated logos, trademarks, product names and trade names associated with RandAI are owned by RandAI. You cannot use any of our labels, or product names without our express written consent.


RandAI, at its discretion, may disable at any time the access to your account and may cancel it if it deems that you have violated any of the terms and conditions specified in this agreement.



</div>

<Footer/>
</div>
</template> -->
