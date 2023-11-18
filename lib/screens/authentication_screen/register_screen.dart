import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/custom_widgets/error_dialog.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen_bloc.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class RegisterScreen extends StatefulWidget {
  final AuthenticationScreenBloc bloc;
  const RegisterScreen({super.key, required this.bloc});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isVisiblePassword = false;
  bool isValidPassword = false;
  bool isTermAndConditionAccepted = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: widget.key,
      slivers: [
        SliverAppBar(
          key: widget.key,
          leading: null,
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          key: widget.key,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeService(context).height * 0.040,
              vertical: SizeService(context).height * 0.010,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              key: widget.key,
              children: [
                Image.asset(
                  "assets/oxt_logo.png",
                  height: 150,
                  alignment: Alignment.topCenter,
                ),
                SizedBox(
                  height: SizeService(context).verticalPadding * 1.0,
                ),
                Text(
                  "Enhancing Trading Decisions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding * 1.0),
                Text(
                  "Sign up",
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeService(context).height * 0.010,
                      vertical: SizeService(context).height * 0.010,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "abcd@email.com",
                            labelText: "Email Address",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          validator: (val) {
                            if (!EmailValidator.validate(val!)) {
                              return "Enter valid email address";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: SizeService(context).verticalPadding),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisiblePassword,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            hintText: "",
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.password_outlined,
                              color: Colors.black54,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisiblePassword = !isVisiblePassword;
                                });
                              },
                              color: isVisiblePassword
                                  ? ThemeService.success
                                  : ThemeService.secondary,
                              icon: Icon(isVisiblePassword
                                  ? Icons.remove_red_eye
                                  : Icons.remove_red_eye_outlined),
                            ),
                          ),
                          validator: (val) {
                            if (isValidPassword == false) {
                              return "Enter valid password";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: SizeService(context).height * 0.02),
                        FlutterPwValidator(
                          controller: passwordController,
                          minLength: 6,
                          uppercaseCharCount: 1,
                          numericCharCount: 2,
                          specialCharCount: 1,
                          width: 400,
                          height: 150,
                          onSuccess: () {
                            setState(() {
                              isValidPassword = true;
                            });
                          },
                          onFail: () {
                            setState(() {
                              isValidPassword = false;
                            });
                          },
                        ),
                        SizedBox(height: SizeService(context).verticalPadding),
                        TextFormField(
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            hintText: "",
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.password_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          validator: (val) {
                            if (val != passwordController.text) {
                              return "Password did not match.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: SizeService(context).verticalPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                activeColor: ThemeService.success,
                                checkColor: ThemeService.light,
                                value: isTermAndConditionAccepted,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                onChanged: (val) {
                                  setState(() {
                                    isTermAndConditionAccepted = val!;
                                  });
                                }),
                            Text(
                              "Please accept our",
                              key: widget.key,
                              style: const TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title:
                                            const Text("Terms and Conditions"),
                                        content: const SingleChildScrollView(
                                          child: Text(
                                            'AGREEMENT TO OUR LEGAL TERMS\n\n'
                                            'We are Options Xpert Trading LLC ("Company," "we," "us," "our"), a company registered in Illinois, United States at 1303 N. Sutton Place, Chicago, IL 60610.\n\n'
                                            'We operate the mobile application Options Xpert Trading (the "App"), as well as any other related products and services that refer or link to these legal terms (the "Legal Terms") (collectively, the "Services").\n\n'
                                            'You can contact us by phone at 3127208017, email at contact@optionsxperttrading.com, or by mail to 1303 N. Sutton Place, Chicago, IL 60610, United States.\n\n'
                                            'These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity ("you"), and Options Xpert Trading LLC, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.\n\n'
                                            'We will provide you with prior notice of any scheduled changes to the Services you are using. The modified Legal Terms will become effective upon posting or notifying you by contact@optionsxperttrading.com, as stated in the email message. By continuing to use the Services after the effective date of any changes, you agree to be bound by the modified terms.\n\n'
                                            'All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Services. If you are a minor, you must have your parent or guardian read and agree to these Legal Terms prior to you using the Services.\n\n'
                                            'We recommend that you print a copy of these Legal Terms for your records.\n\n'
                                            '1. OUR SERVICES\n'
                                            'The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.\n\n'
                                            'The Services are not tailored to comply with industry-specific regulations (Health Insurance Portability and Accountability Act (HIPAA), Federal Information Security Management Act (FISMA), etc.), so if your interactions would be subjected to such laws, you may not use the Services. You may not use the Services in a way that would violate the Gramm-Leach-Bliley Act (GLBA).\n\n'
                                            '2. INTELLECTUAL PROPERTY RIGHTS\n'
                                            'Our intellectual property\n\n'
                                            'We are the owner or the licensee of all intellectual property rights in our Services, including all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics in the Services (collectively, the "Content"), as well as the trademarks, service marks, and logos contained therein (the "Marks").\n\n'
                                            'Our Content and Marks are protected by copyright and trademark laws (and various other intellectual property rights and unfair competition laws) and treaties in the United States and around the world\n'
                                            'The Content and Marks are provided in or through the Services "AS IS" for your personal, non-commercial use or internal business purpose only.\n'
                                            'Your use of our Services\n\n'
                                            'Subject to your compliance with these Legal Terms, including the "PROHIBITED ACTIVITIES" section below, we grant you a non-exclusive, non-transferable, revocable license to:\n'
                                            '- access the Services; and\n'
                                            '- download or print a copy of any portion of the Content to which you have properly gained access.\n'
                                            'solely for your personal, non-commercial use or internal business purpose.\n\n'
                                            'Except as set out in this section or elsewhere in our Legal Terms, no part of the Services and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission.\n\n'
                                            'If you wish to make any use of the Services, Content, or Marks other than as set out in this section or elsewhere in our Legal Terms, please address your request to: contact@optionsxperttrading.com. If we ever grant you the permission to post, reproduce, or publicly display any part of our Services or Content, you must identify us as the owners or licensors of the Services, Content, or Marks and ensure that any copyright or proprietary notice appears or is visible on posting, reproducing, or displaying our Content.\n\n'
                                            'We reserve all rights not expressly granted to you in and to the Services, Content, and Marks.\n\n'
                                            'Any breach of these Intellectual Property Rights will constitute a material breach of our Legal Terms and your right to use our Services will terminate immediately.\n\n'
                                            'Your submissions and contributions\n\n'
                                            'Please review this section and the "PROHIBITED ACTIVITIES" section carefully prior to using our Services to understand the (a) rights you give us and (b) obligations you have when you post or upload any content through the Services.\n\n'
                                            'Submissions: By directly sending us any question, comment, suggestion, idea, feedback, or other information about the Services ("Submissions"), you agree to assign to us all intellectual property rights in such Submission. You agree that we shall own this Submission and be entitled to its unrestricted use and dissemination for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you.\n\n'
                                            'Contributions: The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality during which you may create, submit, post, display, transmit, publish, distribute, or broadcast content and materials to us or through the Services, including but not limited to text, writings, video, audio, photographs, music, graphics, comments, reviews, rating suggestions, personal information, or other material ("Contributions"). Any Submission that is publicly posted shall also be treated as a Contribution.\n\n'
                                            'You understand that Contributions may be viewable by other users of the Services and possibly through third-party websites.\n\n'
                                            'When you post Contributions, you grant us a license (including use of your name, trademarks, and logos): By posting any Contributions, you grant us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to: use, copy, reproduce, distribute, sell, resell, publish, broadcast, retitle, store, publicly perform, publicly display, reformat, translate, excerpt (in whole or in part), and exploit your Contributions (including, without limitation, your image, name and voice) for any purpose, commercial, advertising, or otherwise, to prepare derivative works of, or incorporate into other works, your Contributions, and to sublicense the licenses granted in this section. Our use and distribution may occur in any media formats and through any media channels.'
                                            'This license includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide.\n\n'
                                            'You are responsible for what you post or upload: By sending us Submissions and/or posting Contributions through any part of the Services or making Contributions accessible through the Services by linking your account through the Services to any of your social networking accounts, you:\n'
                                            '- confirm that you have read and agree with our "PROHIBITED ACTIVITIES " and will not post, send, publish, upload, or transmit through the Services any Submission nor post any Contribution that is illegal, harassing, hateful, harmful, defamatory, obscene, bullying, abusive, discriminatory, threatening to any person or group, sexually explicit, false, inaccurate, deceitful, or misleading;\n'
                                            '- to the extent permissible by applicable law, waive any and all moral rights to any such Submission and/or Contribution;\n'
                                            '- warrant that any such Submission and/or Contributions are original to you or that you have the necessary rights and licenses to submit such Submissions and/or Contributions and that you have full authority to grant us the above-mentioned rights in relation to your Submissions and/or Contributions; and\n'
                                            '- warrant and represent that your Submissions and/or Contributions do not constitute confidential information.\n\n'
                                            'You are solely responsible for your Submissions and/or Contributions and you expressly agree to reimburse us for any and all losses that we may suffer because of your breach of (a) this section, (b) any third party`s intellectual property rights, or (c) applicable law.\n\n'
                                            'We may remove or edit your Content: Although we have no obligation to monitor any Contributions, we shall have the right to remove or edit any Contributions at any time without notice if in our reasonable opinion we  consider such Contributions harmful or in breach of these Legal Terms. If we remove or edit any such Contributions, we may also suspend or disable your account and report you to the authorities.\n\n'
                                            '3. USER REPRESENTATIONS\n\n'
                                            'By using the Services, you represent and warrant that:\n'
                                            '- all registration information you submit will be true, accurate, current, and complete;\n'
                                            '- you will maintain the accuracy of such information and promptly update such registration information as necessary;\n'
                                            '- you have the legal capacity and you agree to comply with these Legal Terms;\n'
                                            '- you are not a minor in the jurisdiction in which you reside, or if a minor, you have received parental permission to use the Services;\n'
                                            '- you will not access the Services through automated or non-human means, whether through a bot, script or otherwise;\n'
                                            '- you will not use the Services for any illegal or unauthorized purpose; and\n'
                                            '- your use of the Services will not violate any applicable law or regulation.\n\n'
                                            'If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the Services (or any portion thereof).\n\n'
                                            '4. USER REGISTRATION\n\n'
                                            'You may be required to register to use the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.\n\n'
                                            '5. PURCHASES AND PAYMENT\n\n'
                                            'We accept the following forms of payment:\n\n'
                                            '- PayPal\n'
                                            '- Discover\n'
                                            '- American Express\n'
                                            '- Mastercard\n'
                                            '- Visa\n\n'
                                            'You agree to provide current, complete, and accurate purchase and account information for all purchases made via the Services. You further agree to promptly update account and payment information, including email address, payment method, and payment card expiration date, so that we can complete your transactions and contact you as needed. Sales tax will be added to the price of purchases as deemed required by us. We may change prices at any time. All payments shall be in US dollars.\n\n'
                                            'You agree to pay all charges at the prices then in effect for your purchases and any applicable shipping fees, and you authorize us to charge your chosen payment provider for any such amounts upon placing your order. If your order is subject to recurring charges, then you consent to our charging your payment method on a recurring basis without requiring your prior approval for each recurring charge, until such time as you cancel the applicable order.  We reserve the right to correct any errors or mistakes in pricing, even if we have already requested or received payment.\n\n'
                                            'We reserve the right to refuse any order placed through the Services. We may, in our sole discretion, limit or cancel quantities purchased per person, per household, or per order. These restrictions may include orders placed by or under the same customer account, the same payment method, and/or orders that use the same billing or shipping address. We reserve the right to limit or prohibit orders that, in our sole judgment, appear to be placed by dealers, resellers, or distributors.\n\n'
                                            '6. POLICY\n\n'
                                            'All sales are final and no refund will be issued.\n\n'
                                            '7. PROHIBITED ACTIVITIES\n\n'
                                            'You may not access or use the Services for any purpose other than that for which we make the Services available. The Services may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us.\n\n'
                                            'As a user of the Services, you agree not to:\n\n'
                                            '- Systematically retrieve data or other content from the Services to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us.\n'
                                            '- Trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords.\n'
                                            '- Circumvent, disable, or otherwise interfere with security-related features of the Services, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of the Services and/or the Content contained therein.\n'
                                            '- Disparage, tarnish, or otherwise harm, in our opinion, us and/or the Services.\n'
                                            '- Use any information obtained from the Services in order to harass, abuse, or harm another person.\n'
                                            '- Make improper use of our support services or submit false reports of abuse or misconduct.\n'
                                            '- Use the Services in a manner inconsistent with any applicable laws or regulations.\n'
                                            '- Engage in unauthorized framing of or linking to the Services.\n'
                                            '- Upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party`s uninterrupted use and enjoyment of the Services or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of the Services.'
                                            'Engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools.\n\n'
                                            'Delete the copyright or other proprietary rights notice from any Content.\n\n'
                                            'Attempt to impersonate another user or person or use the username of another user.\n\n'
                                            'Upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats ("gifs"), 1x1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as "spyware" or "passive collection mechanisms" or "pcms" ).\n\n'
                                            'Interfere with, disrupt, or create an undue burden on the Services or the networks or services connected to the Services.\n\n'
                                            'Harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of the Services to you.\n\n'
                                            'Attempt to bypass any measures of the Services designed to prevent or restrict access to the Services, or any portion of the Services.\n\n'
                                            'Copy or adapt the Services\' software, including but not limited to Flash, PHP, HTML, JavaScript, or other code.\n\n'
                                            'Except as permitted by applicable law, decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Services.\n\n'
                                            'Except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses the Services, or use or launch any unauthorized script or other software.\n\n'
                                            'Use a buying agent or purchasing agent to make purchases on the Services.\n\n'
                                            'Make any unauthorized use of the Services, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretenses.\n\n'
                                            'Use the Services as part of any effort to compete with us or otherwise use the Services and/or the Content for any revenue-generating endeavor or commercial enterprise.\n\n'
                                            'Sell or otherwise transfer your profile.\n\n'
                                            'Use the Services to advertise or offer to sell goods and services.\n\n'
                                            '8. USER GENERATED CONTRIBUTIONS\n\n'
                                            'The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality, and may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or on the Services, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, "Contributions"). Contributions may be viewable by other users of the Services and through third-party websites. As such, any Contributions you transmit may be treated as non-confidential and non-proprietary. When you create or make available any Contributions, you thereby represent and warrant that:\n\n'
                                            '- The creation, distribution, transmission, public display, or performance, and the accessing, downloading, or copying of your Contributions do not and will not infringe the proprietary rights, including but not limited to the copyright, patent, trademark, trade secret, or moral rights of any third party.\n\n'
                                            '- You are the creator and owner of or have the necessary licenses, rights, consents, releases, and permissions to use and to authorize us, the Services, and other users of the Services to use your Contributions in any manner contemplated by the Services and these Legal Terms.\n\n'
                                            '- You have the written consent, release, and/or permission of each and every identifiable individual person in your Contributions to use the name or likeness of each and every such identifiable individual person to enable inclusion and use of your Contributions in any manner contemplated by the Services and these Legal Terms.\n\n'
                                            '- Your Contributions are not false, inaccurate, or misleading.\n\n'
                                            '- Your Contributions are not unsolicited or unauthorized advertising, promotional materials, pyramid schemes, chain letters, spam, mass mailings, or other forms of solicitation'
                                            '- Your Contributions are not obscene, lewd, lascivious, filthy, violent, harassing, libelous, slanderous, or otherwise objectionable (as determined by us).\n\n'
                                            '- Your Contributions do not ridicule, mock, disparage, intimidate, or abuse anyone.\n\n'
                                            '- Your Contributions are not used to harass or threaten (in the legal sense of those terms) any other person and to promote violence against a specific person or class of people.\n\n'
                                            '- Your Contributions do not violate any applicable law, regulation, or rule.\n\n'
                                            '- Your Contributions do not violate the privacy or publicity rights of any third party.\n\n'
                                            '- Your Contributions do not violate any applicable law concerning child pornography, or otherwise intended to protect the health or well-being of minors.\n\n'
                                            '- Your Contributions do not include any offensive comments that are connected to race, national origin, gender, sexual preference, or physical handicap.\n\n'
                                            '- Your Contributions do not otherwise violate, or link to material that violates, any provision of these Legal Terms, or any applicable law or regulation.\n\n'
                                            '- Any use of the Services in violation of the foregoing violates these Legal Terms and may result in, among other things, termination or suspension of your rights to use the Services.\n\n'
                                            '9. CONTRIBUTION LICENSE\n'
                                            '- By posting your Contributions to any part of the Services, you automatically grant, and you represent and warrant that you have the right to grant, to us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to host, use, copy, reproduce, disclose, sell, resell, publish, broadcast, retitle, archive, store, cache, publicly perform, publicly display, reformat, translate, transmit, excerpt (in whole or in part), and distribute such Contributions (including, without limitation, your image and voice) for any purpose, commercial, advertising, or otherwise, and to prepare derivative works of, or incorporate into other works, such Contributions, and grant and authorize sublicenses of the foregoing. The use and distribution may occur in any media formats and through any media channels.\n\n'
                                            '- This license will apply to any form, media, or technology now known or hereafter developed, and includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide. You waive all moral rights in your Contributions, and you warrant that moral rights have not otherwise been asserted in your Contributions.\n\n'
                                            '- We do not assert any ownership over your Contributions. You retain full ownership of all of your Contributions and any intellectual property rights or other proprietary rights associated with your Contributions. We are not liable for any statements or representations in your Contributions provided by you in any area on the Services. You are solely responsible for your Contributions to the Services and you expressly agree to exonerate us from any and all responsibility and to refrain from any legal action against us regarding your Contributions.\n\n'
                                            '- We have the right, in our sole and absolute discretion, (1) to edit, redact, or otherwise change any Contributions; (2) to re-categorize any Contributions to place them in more appropriate locations on the Services; and (3) to pre-screen or delete any Contributions at any time and for any reason, without notice. We have no obligation to monitor your Contributions.\n\n'
                                            '10. GUIDELINES FOR REVIEWS\n\n'
                                            'We may provide you areas on the Services to leave reviews or ratings. When posting a review, you must comply with the following criteria: (1) you should have firsthand experience with the person/entity being reviewed; (2) your reviews should not contain offensive profanity, or abusive, racist, offensive, or hateful language; (3) your reviews should not contain discriminatory references based on religion, race, gender, national origin, age, marital status, sexual orientation, or disability; (4) your reviews should not contain references to illegal activity; (5) you should not be affiliated with competitors if posting negative reviews; (6) you should not make any conclusions as to the legality of conduct; (7) you may not post any false or misleading statements; and (8) you may not organize a campaign encouraging others to post reviews, whether positive or negative.We may accept, reject, or remove reviews in our sole discretion. We have absolutely no obligation to screen reviews or to delete reviews, even if anyone considers reviews objectionable or inaccurate. Reviews are not endorsed by us, and do not necessarily represent our opinions or the views of any of our affiliates or partners. We do not assume liability for any review or for any claims, liabilities, or losses resulting from any review. By posting a review, you hereby grant to us a perpetual, non-exclusive, worldwide, royalty-free, fully paid, assignable, and sublicensable right and license to reproduce, modify, translate, transmit by any means, display, perform, and/or distribute all content relating to review.'
                                            '11. MOBILE APPLICATION LICENSE\n\n'
                                            'Use License\n'
                                            '- You are granted a revocable, non-exclusive, non-transferable, limited right to install and use the App on wireless electronic devices owned or controlled by you, and to access and use the App on such devices strictly in accordance with the terms and conditions of this mobile application license contained in these Legal Terms.\n'
                                            '- You shall not:\n'
                                            '  1. except as permitted by applicable law, decompile, reverse engineer, disassemble, attempt to derive the source code of, or decrypt the App;\n'
                                            '  2. make any modification, adaptation, improvement, enhancement, translation, or derivative work from the App;\n'
                                            '  3. violate any applicable laws, rules, or regulations in connection with your access or use of the App;\n'
                                            '  4. remove, alter, or obscure any proprietary notice (including any notice of copyright or trademark) posted by us or the licensors of the App;\n'
                                            '  5. use the App for any revenue-generating endeavor, commercial enterprise, or other purpose for which it is not designed or intended;\n'
                                            '  6. make the App available over a network or other environment permitting access or use by multiple devices or users at the same time;\n'
                                            '  7. use the App for creating a product, service, or software that is, directly or indirectly, competitive with or in any way a substitute for the App;\n'
                                            '  8. use the App to send automated queries to any website or to send any unsolicited commercial email; or\n'
                                            '  9. use any proprietary information or any of our interfaces or our other intellectual property in the design, development, manufacture, licensing, or distribution of any applications, accessories, or devices for use with the App.\n\n'
                                            'Apple and Android Devices\n'
                                            '- The following terms apply when you use the App obtained from either the Apple Store or Google Play (each an "App Distributor") to access the Services:\n'
                                            '  1. the license granted to you for our App is limited to a non-transferable license to use the application on a device that utilizes the Apple iOS or Android operating systems, as applicable, and in accordance with the usage rules set forth in the applicable App Distributor’s terms of service;\n'
                                            '  2. we are responsible for providing any maintenance and support services with respect to the App as specified in the terms and conditions of this mobile application license contained in these Legal Terms or as otherwise required under applicable law, and you acknowledge that each App Distributor has no obligation whatsoever to furnish any maintenance and support services with respect to the App;\n'
                                            '  3. in the event of any failure of the App to conform to any applicable warranty, you may notify the applicable App Distributor, and the App Distributor, in accordance with its terms and policies, may refund the purchase price, if any, paid for the App, and to the maximum extent permitted by applicable law, the App Distributor will have no other warranty obligation whatsoever with respect to the App;\n'
                                            '  4. you represent and warrant that (i) you are not located in a country that is subject to a US government embargo, or that has been designated by the US government as a "terrorist supporting" country and (ii) you are not listed on any US government list of prohibited or restricted parties;\n'
                                            '  5.you must comply with applicable third-party terms of agreement when using the App, e.g., if you have a VoIP application, then you must not be in violation of their wireless data service agreement when using the App'
                                            '6. You acknowledge and agree that the App Distributors are third-party beneficiaries of the terms and conditions in this mobile application license contained in these Legal Terms, and that each App Distributor will have the right (and will be deemed to have accepted the right) to enforce the terms and conditions in this mobile application license contained in these Legal Terms against you as a third-party beneficiary thereof.\n\n'
                                            '12. THIRD-PARTY WEBSITES AND CONTENT\n\n'
                                            '- The Services may contain (or you may be sent via the App) links to other websites ("Third-Party Websites") as well as articles, photographs, text, graphics, pictures, designs, music, sound, video, information, applications, software, and other content or items belonging to or originating from third parties ("Third-Party Content").\n'
                                            '- Such Third-Party Websites and Third-Party Content are not investigated, monitored, or checked for accuracy, appropriateness, or completeness by us, and we are not responsible for any Third-Party Websites accessed through the Services or any Third-Party Content posted on, available through, or installed from the Services.\n'
                                            '- Inclusion of, linking to, or permitting the use or installation of any Third-Party Websites or any Third-Party Content does not imply approval or endorsement thereof by us.\n'
                                            '- If you decide to leave the Services and access the Third-Party Websites or to use or install any Third-Party Content, you do so at your own risk, and you should be aware these Legal Terms no longer govern.\n'
                                            '- Any purchases you make through Third-Party Websites will be through other websites and from other companies, and we take no responsibility whatsoever in relation to such purchases which are exclusively between you and the applicable third party.\n'
                                            '- You agree and acknowledge that we do not endorse the products or services offered on Third-Party Websites and you shall hold us blameless from any harm caused by your purchase of such products or services.\n'
                                            '- Additionally, you shall hold us blameless from any losses sustained by you or harm caused to you relating to or resulting in any way from any Third-Party Content or any contact with Third-Party Websites.\n\n'
                                            '13. SERVICES MANAGEMENT\n\n'
                                            '- We reserve the right, but not the obligation, to:\n'
                                            '  (1) monitor the Services for violations of these Legal Terms;\n'
                                            '  (2) take appropriate legal action against anyone who, in our sole discretion, violates the law or these Legal Terms, including without limitation, reporting such user to law enforcement authorities;\n'
                                            '  (3) in our sole discretion and without limitation, refuse, restrict access to, limit the availability of, or disable (to the extent technologically feasible) any of your Contributions or any portion thereof;\n'
                                            '  (4) in our sole discretion and without limitation, notice, or liability, to remove from the Services or otherwise disable all files and content that are excessive in size or are in any way burdensome to our systems; and\n'
                                            '  (5) otherwise manage the Services in a manner designed to protect our rights and property and to facilitate the proper functioning of the Services.\n\n'
                                            '14. PRIVACY POLICY\n\n'
                                            '- We care about data privacy and security.\n\n'
                                            '- By using the Services, you agree to be bound by our Privacy Policy posted on the Services, which is incorporated into these Legal Terms.\n\n'
                                            '- Please be advised the Services are hosted in the United States.\n\n'
                                            '- If you access the Services from any other region of the world with laws or other requirements governing personal data collection, use, or disclosure that differ from applicable laws in the United States, then through your continued use of the Services, you are transferring your data to the United States, and you expressly consent to have your data transferred to and processed in the United States.\n\n'
                                            '15. TERM AND TERMINATION\n\n'
                                            '- These Legal Terms shall remain in full force and effect while you use the Services.\n\n'
                                            '- WITHOUT LIMITING ANY OTHER PROVISION OF THESE LEGAL TERMS, WE RESERVE THE RIGHT TO, IN OUR SOLE DISCRETION AND WITHOUT NOTICE OR LIABILITY, DENY ACCESS TO AND USE OF THE SERVICES (INCLUDING BLOCKING CERTAIN IP ADDRESSES), TO ANY PERSON FOR ANY REASON OR FOR NO REASON, INCLUDING WITHOUT LIMITATION FOR BREACH OF ANY REPRESENTATION, WARRANTY, OR COVENANT CONTAINED IN THESE LEGAL TERMS OR OF ANY APPLICABLE LAW OR REGULATION.\n\n'
                                            '- WE MAY TERMINATE YOUR USE OR PARTICIPATION IN THE SERVICES OR DELETE YOUR ACCOUNT AND ANY CONTENT OR INFORMATION THAT YOU POSTED AT ANY TIME, WITHOUT WARNING, IN OUR SOLE DISCRETION.\n\n'
                                            '- If we terminate or suspend your account for any reason, you are prohibited from registering and creating a new account under your name, a fake or borrowed name, or the name of any third party, even if you may be acting on behalf of the third party.\n\n'
                                            '- In addition to terminating or suspending your account, we reserve the right to take appropriate legal action, including without limitation pursuing civil, criminal, and injunctive redress.'
                                            '16. MODIFICATIONS AND INTERRUPTIONS\n\n'
                                            '- We reserve the right to change, modify, or remove the contents of the Services at any time or for any reason at our sole discretion without notice. However, we have no obligation to update any information on our Services. We will not be liable to you or any third party for any modification, price change, suspension, or discontinuance of the Services.\n\n'
                                            '- We cannot guarantee the Services will be available at all times. We may experience hardware, software, or other problems or need to perform maintenance related to the Services, resulting in interruptions, delays, or errors. We reserve the right to change, revise, update, suspend, discontinue, or otherwise modify the Services at any time or for any reason without notice to you. You agree that we have no liability whatsoever for any loss, damage, or inconvenience caused by your inability to access or use the Services during any downtime or discontinuance of the Services. Nothing in these Legal Terms will be construed to obligate us to maintain and support the Services or to supply any corrections, updates, or releases in connection therewith.\n\n'
                                            '17. GOVERNING LAW\n\n'
                                            '- These Legal Terms and your use of the Services are governed by and construed in accordance with the laws of the State of Illinois applicable to agreements made and to be entirely performed within the State of Illinois, without regard to its conflict of law principles.\n\n'
                                            '18. DISPUTE RESOLUTION\n\n'
                                            'Informal Negotiations\n\n'
                                            '- To expedite resolution and control the cost of any dispute, controversy, or claim related to these Legal Terms (each a "Dispute" and collectively, the "Disputes") brought by either you or us (individually, a "Party" and collectively, the "Parties"), the Parties agree to first attempt to negotiate any Dispute (except those Disputes expressly provided below) informally for at least thirty (30) days before initiating arbitration. Such informal negotiations commence upon written notice from one Party to the other Party.\n\n'
                                            'Binding Arbitration\n\n'
                                            'If the Parties are unable to resolve a Dispute through informal negotiations, the Dispute (except those Disputes expressly excluded below) will be finally and exclusively resolved by binding arbitration. YOU UNDERSTAND THAT WITHOUT THIS PROVISION, YOU WOULD HAVE THE RIGHT TO SUE IN COURT AND HAVE A JURY TRIAL. \n\n'
                                            'The arbitration shall be commenced and conducted under the Commercial Arbitration Rules of the American Arbitration Association ("AAA" ) and, where appropriate, the AAA’s Supplementary Procedures for Consumer Related Disputes ("AAA Consumer Rules"), both of which are available at the American Arbitration Association (AAA) website. Your arbitration fees and your share of arbitrator compensation shall be governed by the AAA Consumer Rules and, where appropriate, limited by the AAA Consumer Rules. The arbitration may be conducted in person, through the submission of documents, by phone, or online. The arbitrator will make a decision in writing, but need not provide a statement of reasons unless requested by either Party. The arbitrator must follow applicable law, and any award may be challenged if the arbitrator fails to do so. Except where otherwise required by the applicable AAA rules or applicable law, the arbitration will take place in Cook, Illinois .\n\n'
                                            'Except as otherwise provided herein, the Parties may litigate in court to compel arbitration, stay proceedings pending arbitration, or to confirm, modify, vacate, or enter judgment on the award entered by the arbitrator.\n\n'
                                            'If for any reason, a Dispute proceeds in court rather than arbitration, the Dispute shall be commenced or prosecuted in the state and federal courts located in Cook, Illinois, and the Parties hereby consent to, and waive all defenses of lack of personal jurisdiction, and forum non conveniens with respect to venue and jurisdiction in such state and federal courts. Application of the United Nations Convention on Contracts for the International Sale of Goods and the Uniform Computer Information Transaction Act (UCITA) are excluded from these Legal Terms.\n\n'
                                            'In no event shall any Dispute brought by either Party related in any way to the Services be commenced more than one (1) years after the cause of action arose. If this provision is found to be illegal or unenforceable, then neither Party will elect to arbitrate any Dispute falling within that portion of this provision found to be illegal or unenforceable and such Dispute shall be decided by a court of competent jurisdiction within the courts listed for jurisdiction above, and the Parties agree to submit to the personal jurisdiction of that court.\n\n'
                                            'Restrictions\n\n'
                                            'The Parties agree that any arbitration shall be limited to the Dispute between the Parties individually. To the full extent permitted by law, (a) no arbitration shall be joined with any other proceeding; (b) there is no right or authority for any Dispute to be arbitrated on a class-action basis or to utilize class action procedures; and (c) there is no right or authority for any Dispute to be brought in a purported representative capacity on behalf of the general public or any other persons.'
                                            'Exceptions to Informal Negotiations and Arbitration\n\n'
                                            'The Parties agree that the following Disputes are not subject to the above provisions concerning informal negotiations binding arbitration: \n'
                                            '(a) any Disputes seeking to enforce or protect, or concerning the validity of, any of the intellectual property rights of a Party; \n'
                                            '(b) any Dispute related to, or arising from, allegations of theft, piracy, invasion of privacy, or unauthorized use; and \n'
                                            '(c) any claim for injunctive relief. If this provision is found to be illegal or unenforceable, then neither Party will elect to arbitrate any Dispute falling within that portion of this provision found to be illegal or unenforceable and such Dispute shall be decided by a court of competent jurisdiction within the courts listed for jurisdiction above, and the Parties agree to submit to the personal jurisdiction of that court.\n\n'
                                            '19. CORRECTIONS\n\n'
                                            'There may be information on the Services that contains typographical errors, inaccuracies, or omissions, including descriptions, pricing, availability, and various other information. We reserve the right to correct any errors, inaccuracies, or omissions and to change or update the information on the Services at any time, without prior notice.\n\n'
                                            '20. DISCLAIMER\n\n'
                                            'THE SERVICES ARE PROVIDED ON AN AS-IS AND AS-AVAILABLE BASIS. YOU AGREE THAT YOUR USE OF THE SERVICES WILL BE AT YOUR SOLE RISK. TO THE FULLEST EXTENT PERMITTED BY LAW, WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, IN CONNECTION WITH THE SERVICES AND YOUR USE THEREOF, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. WE MAKE NO WARRANTIES OR REPRESENTATIONS ABOUT THE ACCURACY OR COMPLETENESS OF THE SERVICES\' CONTENT OR THE CONTENT OF ANY WEBSITES OR MOBILE APPLICATIONS LINKED TO THE SERVICES AND WE WILL ASSUME NO LIABILITY OR RESPONSIBILITY FOR ANY (1) ERRORS, MISTAKES, OR INACCURACIES OF CONTENT AND MATERIALS, (2) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF THE SERVICES, (3) ANY UNAUTHORIZED ACCESS TO OR USE OF OUR SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (4) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM THE SERVICES, (5) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE WHICH MAY BE TRANSMITTED TO OR THROUGH THE SERVICES BY ANY THIRD PARTY, AND/OR (6) ANY ERRORS OR OMISSIONS IN ANY CONTENT AND MATERIALS OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF THE USE OF ANY CONTENT POSTED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE SERVICES. WE DO NOT WARRANT, ENDORSE, GUARANTEE, OR ASSUME RESPONSIBILITY FOR ANY PRODUCT OR SERVICE ADVERTISED OR OFFERED BY A THIRD PARTY THROUGH THE SERVICES, ANY HYPERLINKED WEBSITE, OR ANY WEBSITE OR MOBILE APPLICATION FEATURED IN ANY BANNER OR OTHER ADVERTISING, AND WE WILL NOT BE A PARTY TO OR IN ANY WAY BE RESPONSIBLE FOR MONITORING ANY TRANSACTION BETWEEN YOU AND ANY THIRD-PARTY PROVIDERS OF PRODUCTS OR SERVICES. AS WITH THE PURCHASE OF A PRODUCT OR SERVICE THROUGH ANY MEDIUM OR IN ANY ENVIRONMENT, YOU SHOULD USE YOUR BEST JUDGMENT AND EXERCISE CAUTION WHERE APPROPRIATE.'
                                            '21. LIMITATIONS OF LIABILITY\n\n'
                                            'IN NO EVENT WILL WE OR OUR DIRECTORS, EMPLOYEES, OR AGENTS BE LIABLE TO YOU OR ANY THIRD PARTY FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, EXEMPLARY, INCIDENTAL, SPECIAL, OR PUNITIVE DAMAGES, INCLUDING LOST PROFIT, LOST REVENUE, LOSS OF DATA, OR OTHER DAMAGES ARISING FROM YOUR USE OF THE SERVICES, EVEN IF WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. NOTWITHSTANDING ANYTHING TO THE CONTRARY CONTAINED HEREIN, OUR LIABILITY TO YOU FOR ANY CAUSE WHATSOEVER AND REGARDLESS OF THE FORM OF THE ACTION, WILL AT ALL TIMES BE LIMITED TO THE LESSER OF THE AMOUNT PAID, IF ANY, BY YOU TO US DURING THE SIX (6) MONTH PERIOD PRIOR TO ANY CAUSE OF ACTION ARISING OR 100.00 USD .\n\n'
                                            'CERTAIN US STATE LAWS AND INTERNATIONAL LAWS DO NOT ALLOW LIMITATIONS ON IMPLIED WARRANTIES OR THE EXCLUSION OR LIMITATION OF CERTAIN DAMAGES. IF THESE LAWS APPLY TO YOU, SOME OR ALL OF THE ABOVE DISCLAIMERS OR LIMITATIONS MAY NOT APPLY TO YOU, AND YOU MAY HAVE ADDITIONAL RIGHTS.\n\n'
                                            '22. INDEMNIFICATION\n\n'
                                            'You agree to defend, indemnify, and hold us harmless, including our subsidiaries, affiliates, and all of our respective officers, agents, partners, and employees, from and against any loss, damage, liability, claim, or demand, including reasonable attorneys` fees and expenses, made by any third party due to or arising out of: (1) your Contributions;  (2) use of the Services; (3) breach of these Legal Terms; (4) any breach of your representations and warranties set forth in these Legal Terms; (5) your violation of the rights of a third party, including but not limited to intellectual property rights; or (6) any overt harmful act toward any other user of the Services with whom you connected via the Services. Notwithstanding the foregoing, we reserve the right, at your expense, to assume the exclusive defense and control of any matter for which you are required to indemnify us, and you agree to cooperate, at your expense, with our defense of such claims. We will use reasonable efforts to notify you of any such claim, action, or proceeding which is subject to this indemnification upon becoming aware of it.'
                                            '23. USER DATA\n\nWe will maintain certain data that you transmit to the Services for the purpose of managing the performance of the Services, as well as data relating to your use of the Services. Although we perform regular routine backups of data, you are solely responsible for all data that you transmit or that relates to any activity you have undertaken using the Services. You agree that we shall have no liability to you for any loss or corruption of any such data, and you hereby waive any right of action against us arising from any such loss or corruption of such data.\n\n24. ELECTRONIC COMMUNICATIONS, TRANSACTIONS, AND SIGNATURES\n\nVisiting the Services, sending us emails, and completing online forms constitute electronic communications. You consent to receive electronic communications, and you agree that all agreements, notices, disclosures, and other communications we provide to you electronically, via email and on the Services, satisfy any legal requirement that such communication be in writing. YOU HEREBY AGREE TO THE USE OF ELECTRONIC SIGNATURES, CONTRACTS, ORDERS, AND OTHER RECORDS, AND TO ELECTRONIC DELIVERY OF NOTICES, POLICIES, AND RECORDS OF TRANSACTIONS INITIATED OR COMPLETED BY US OR VIA THE SERVICES. You hereby waive any rights or requirements under any statutes, regulations, rules, ordinances, or other laws in any jurisdiction which require an original signature or delivery or retention of non-electronic records, or to payments or the granting of credits by any means other than electronic means.\n\n25. CALIFORNIA USERS AND RESIDENTS\n\nIf any complaint with us is not satisfactorily resolved, you can contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 North Market Blvd., Suite N 112, Sacramento, California 95834 or by telephone at (800) 952-5210 or (916) 445-1254.\n\n26. MISCELLANEOUS\n\nThese Legal Terms and any policies or operating rules posted by us on the Services or in respect to the Services constitute the entire agreement and understanding between you and us. Our failure to exercise or enforce any right or provision of these Legal Terms shall not operate as a waiver of such right or provision. These Legal Terms operate to the fullest extent permissible by law. We may assign any or all of our rights and obligations to others at any time. We shall not be responsible or liable for any loss, damage, delay, or failure to act caused by any cause beyond our reasonable control. If any provision or part of a provision of these Legal Terms is determined to be unlawful, void, or unenforceable, that provision or part of the provision is deemed severable from these Legal Terms and does not affect the validity and enforceability of any remaining provisions. There is no joint venture, partnership, employment or agency relationship created between you and us as a result of these Legal Terms or use of the Services. You agree that these Legal Terms will not be construed against us by virtue of having drafted them. You hereby waive any and all defenses you may have based on the electronic form of these Legal Terms and the lack of signing by the parties hereto to execute these Legal Terms.'
                                            '27. CONTACT US'
                                            'In order to resolve a complaint regarding the Services or to receive further information regarding use of the Services, please contact us at:\n\nOptions Xpert Trading LLC\n1303 N. Sutton Place\nChicago, IL 60610\nUnited States\nPhone: 3127208017\ncontact@optionsxperttrading.com',
                                          ),
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isTermAndConditionAccepted =
                                                    true;
                                              });
                                              Navigator.pop(ctx);
                                            },
                                            style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    ThemeService.light,
                                                backgroundColor:
                                                    ThemeService.success),
                                            child: const Text("ACCEPT"),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                isTermAndConditionAccepted =
                                                    false;
                                              });
                                              Navigator.pop(ctx);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  ThemeService.error,
                                            ),
                                            child: const Text("DENY"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                "Terms & Conditions",
                                style: GoogleFonts.baskervville(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 25,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                isTermAndConditionAccepted) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: passwordController.text.trim())
                                  .catchError((error) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ErrorDialog(
                                        message: error
                                            .toString()
                                            .split("]")[1]
                                            .trim(),
                                        title: "Sign Up Error",
                                      );
                                    });
                              });
                            }
                          },
                          child: Text(
                            "Register",
                            key: widget.key,
                            style: GoogleFonts.baskervville(
                              fontSize: SizeService(context).height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeService(context).verticalPadding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              key: widget.key,
                            ),
                            TextButton(
                              onPressed: () {
                                widget.bloc.update(FormType.login);
                              },
                              child: Text(
                                "Sign in",
                                style: GoogleFonts.baskervville(
                                  fontSize: SizeService(context).height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
