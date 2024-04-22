import 'package:flutter/material.dart';

enum Location { gate, canteen, micmac, mechc, oat, audi, acaddept }

class TNCScreen extends StatefulWidget {
  static String routeName = '/tnc-screen';
  TNCScreen({Key? key}) : super(key: key);

  @override
  _TNCScreenState createState() => _TNCScreenState();
}

class _TNCScreenState extends State<TNCScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ListTile(
                subtitle: Text(
                    "dtuNavigation goal is to create a community of Electric Vehicle users, to deliver charging stations information and a broad range of  services to help make the EV driving experience easy and comfortable. This privacy policy sets forth the personal information that dtuNavigation collects from you through our interactions with you, The Policy discusses how we use that personal information and how you may interact with us better."),
              ),
              ListTile(
                subtitle: Text(
                    "Please read this Policy carefully to understand our policies and practices regarding your personal information and how we will treat it. By submitting personal information to us and/or by using our Services, you give your consent that all personal information that you submit may be processed by us in the manner and for the purposes described below. If you do not want us to process your personal information, please do not provide it; however, you may not be able to take advantage of our Services or certain features of our Services."),
              ),
              ListTile(
                title: Text("1. SCOPE OF THIS POLICY"),
                subtitle: Text(
                    "This Policy applies to all personal information provided to us when you use our websites (_). This Policy does not apply to any third party site or service linked to or from our website. It also does not apply to the third parties who host our social media channels (e.g., Twitter, Facebook, Instagram or Pinterest)."),
              ),
              ListTile(
                title: Text(
                    "2. WHAT INFORMATION WE COLLECT AND USE INFORMATION COLLECTED THROUGH COOKIES, WEB BEACONS ETC."),
                subtitle: Text(
                    "We, or service providers on our behalf, may use technologies such as “cookies”, “web beacons,” “tags”, “scripts” and other tracking technologies to automatically collect personal information from you when you use our Services. Cookies are small amounts of data that are stored within your Internet browser, which saves and recognizes your browsing habits. dtuNavigation uses both session cookies (which track a user’s progression during one site visit) and persistent cookies (which track a user over time). Web beacons (also called pixel tags or clear GIFs) are web page elements that can help deliver cookies, count visits, track browser type, identify your IP address, understand usage and marketing campaign effectiveness, recognize certain types of information on your computer, in your e-mail or on your mobile device, such as the time and date you viewed a page, which e-mails are opened, which links are clicked, and similar information. Among other things, we collect this information to improve our Services and your experience, to see which areas and features of our Services are popular and to count visits, to provide you targeted advertising based upon your interests and to analyze trends, to administer our Services, to track users’ movements around our Services, to gather demographic information about our user base as a whole, and to remember users’ settings and for authentication purposes. Our collection and processing of cookies is described in greater detail in our Cookie Policy which may be found here."),
              ),
              ListTile(
                subtitle: Text(
                    "We may also use web beacons to help deliver cookies described above, as well as to count visits, track browser type, identify your IP address, understand usage and marketing campaign effectiveness, recognize certain types of information on your computer, in your e-mail, or on your mobile device, and to identify which e-mails are opened, which links are clicked, and similar information."),
              ),
              ListTile(
                title: Text("DEVICE, NETWORK, GEOLOCATION, AND EV INFORMATION"),
                subtitle: Text(
                    "We collect information from the devices and networks that you use to access our Services. When you visit or leave our websites or services by clicking a hyperlink or view a plugin on a third party website, we automatically receive the URL of the site from which you came or the one to which you are directed. Also, advertisers receive the URL of the page that you are on when you click on any ad that may appear on our Services. We also receive the internet protocol (“IP”) address of your computer or the proxy server that you use to access the Internet, your computer operating system details, your type of web browser, your mobile device, your mobile operating system, and the name of your ISP or your mobile carrier."),
              ),
              ListTile(
                subtitle: Text(
                    "We may also receive geolocation data passed to us from third party services or GPS-enabled devices that you have authorized, which we use to show you local information (for example, a local charging station) on our website that we provide to you. To opt-out of sharing your location with us, please refer to your device settings."),
              ),
              ListTile(
                title: Text("E-MAIL ADDRESSES"),
                subtitle: Text(
                    "To become a registered user of our Services (which is required in order to be able to share reviews, photos and messages with other users), we collect your e-mail address for account management purposes. Whenever our websites or services offer a link to send e-mail messages to the website or service, your e-mail address is collected, so that the website or service may reply to your inquiry."),
              ),
              ListTile(
                title: Text("OTHER"),
                subtitle: Text(
                    "Because dtuNavigation is constantly innovating and developing ways to improve its services, we may create new ways to collect and use information. We often introduce new features, some of which may result in the collection of new information. Furthermore, new partnerships or corporate acquisitions may result in new features, and these may potentially result in collection of new types of information. In such cases, we will inform our users of these functionalities and partnerships by updating our privacy policies from time to time."),
              ),
              ListTile(
                title: Text("USER SHARED INFORMATION"),
                subtitle: Text(
                    "In addition to automatically collected information, some of our Services ask users to share additional information. We collect user shared information when you visit or use our websites or services, or interact with any advertising on our websites or services. "),
              ),
              ListTile(
                title: Text("SERVICE AND SUPPORT INFORMATION"),
                subtitle: Text(
                    "With respect to all of our Services, when you contact us for support or assistance, we will collect information that helps us to categorize your question, respond to it, and, if applicable, investigate any breach of our Terms of Use or this Policy. We also use this information to track potential problems and trends and customize our support responses to better serve you."),
              ),
              ListTile(
                title: Text("POLLS AND SURVEYS"),
                subtitle: Text(
                    "Polls and surveys may be conducted by certain of our Services, or regarding our services, dtuNavigation develop new programs or products based on the information you share in the surveys. If the surveys requires your contact information, you may be asked to provide personal information to us. It is up to you whether you provide this information, or whether you desire to take advantage of any services. "),
              ),
              ListTile(
                title: Text(
                    "3. HOW WE SHARE PERSONAL INFORMATION WITH THIRD PARTIES"),
                subtitle: Text(
                    "dtuNavigation may disclose personal information in the following circumstances:"),
              ),
              ListTile(
                title: Text("BUSINESS PARTNERS AND SUBCONTRACTORS"),
                subtitle: Text(
                    "dtuNavigation shares personal information with business partners and subcontractors, including without limitation, affiliates, vendors, service providers and suppliers. These third parties assist us in our business including maintaining our Services, referring customers to us, developing and improving products, communicating with you about issues with our Services, marketing, and in connection with any contract we have with an individual or entity or to accomplish a legitimate business need. the business is only authorized to use your personal information as necessary to comply with our contractual agreements and not for secondary purposes unless the data has been anonymized."),
              ),
              ListTile(
                title: Text("THIRD PARTY ANALYTICS PROVIDERS"),
                subtitle: Text(
                    "dtuNavigation shares personal information with third parties who conduct marketing studies and data analytics, including those that provide tools or code which facilitates our review and management of our Services, such as Google Analytics or similar software products from other providers."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
