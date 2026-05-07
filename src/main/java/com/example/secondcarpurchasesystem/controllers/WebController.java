package com.example.secondcarpurchasesystem.controllers;

import com.example.secondcarpurchasesystem.dto.BidDto;
import com.example.secondcarpurchasesystem.models.*;
import com.example.secondcarpurchasesystem.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class WebController {

    private UserService userService;
    private CarService carService;
    private AdvertisementService advertisementService;
    private AuctionService auctionService;
    private BidService bidService;

    @Autowired
    WebController(UserService userService,CarService carService,AdvertisementService advertisementService,AuctionService auctionService,BidService bidService){
        this.userService = userService;
        this.carService = carService;
        this.advertisementService = advertisementService;
        this.auctionService = auctionService;
        this.bidService = bidService;
    }

    // Auth Pages
    @GetMapping("/login")
    public String loginPage() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    // Dashboard and Main Pages
    @GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }

    @GetMapping("/")
    public String homePage(Model model) throws IOException {
        List<Car> cars = carService.getAllActiveCars();
        List<Auction> auctions= auctionService.getAllActiveAuctions();
        List<Advertisement> advertisements = advertisementService.getAllActiveAds();

        model.addAttribute("auctions",auctions);
        model.addAttribute("cars",cars);
        model.addAttribute("ads",advertisements);

        return "home";
    }

    @GetMapping("/all-cars")
    public String allCars(Model model) throws IOException {
        List<Car> cars = carService.getAllActiveCars();
        model.addAttribute("cars",cars);
        return "home/all_cars";
    }

    @GetMapping("/all-auctions")
    public String allAuctions(Model model) throws IOException {
        List<Auction> auctions= auctionService.getAllActiveAuctions();
        model.addAttribute("auctions",auctions);
        return "home/all_auctions";
    }

    @GetMapping("/dashboard/profile/{email}")
    public String profile(@PathVariable String email, Model model) throws IOException {
        Optional<User> user = userService.getUserByEmail(email);
        if(user.isPresent()){
            model.addAttribute("user",user);
            return "home/profile";
        }
        return "home";
    }

    @GetMapping("/car/{carId}")
    public String singleCarView(@PathVariable String carId, Model model) throws IOException {
        Optional<Car> car = carService.getCarById(carId);
        if(car.isPresent()){
            System.out.println(car.get().getImageUrl());
            model.addAttribute("car",car.get());
            return "home/single_car";
        }
        return "home/all_cars";
    }

    @GetMapping("/bid/{auctionId}")
    public String placeBidView(@PathVariable String auctionId,Model model) throws IOException {
        Optional<Auction> auction = auctionService.getAuctionById(auctionId);
        if(auction.isPresent()){
            Optional<Car> car = carService.getCarById(auction.get().getCar().getId());

            if(car.isPresent()){
                model.addAttribute("auction",auction.get());
                model.addAttribute("car",car.get());
                return "home/place_bid";
            }
        }
        return "home/all_cars";
    }

    @GetMapping("/bid-edit/{bidId}")
    public String editBid(@PathVariable String bidId,Model model) throws IOException {
        return "home/all_cars";
    }

    @GetMapping("/my-bids/{email}")
    public String myBids(@PathVariable String email, Model model) throws IOException {
        List<Bid> rawBids = bidService.getBidsByUserEmail(email);
        List<Auction> auctions = auctionService.getAllAuctions();
        List<User> users = userService.getAllUsers();
        List<Car> cars = carService.getAllActiveCars();

        List<BidDto> bids = mapToBidDtos(rawBids, auctions, users, cars);

        model.addAttribute("bids", bids);
        return "home/my_bids";
    }

    @GetMapping("/dashboard/bids")
    public String allBids(Model model) throws IOException {
        List<Bid> rawBids = bidService.getAllActiveBids();
        List<Auction> auctions = auctionService.getAllAuctions();
        List<User> users = userService.getAllUsers();
        List<Car> cars = carService.getAllActiveCars();

        List<BidDto> bids = mapToBidDtos(rawBids, auctions, users, cars);

        model.addAttribute("bids", bids);
        return "bids/all_bids";
    }

    private List<BidDto> mapToBidDtos(List<Bid> rawBids, List<Auction> auctions, List<User> users, List<Car> cars) {
        List<BidDto> bidDtos = new ArrayList<>();

        for (Bid bid : rawBids) {
            BidDto bidDto = new BidDto();

            // Set bid properties
            bidDto.setId(bid.getId());
            bidDto.setBidAmount(bid.getBidAmount());
            bidDto.setStatus(bid.getStatus());

            // Find and set user
            users.stream()
                    .filter(user -> user.getEmail().equals(bid.getUserEmail()))
                    .findFirst()
                    .ifPresent(bidDto::setUser);

            // Find and set auction
            auctions.stream()
                    .filter(auction -> auction.getId().equals(bid.getAuctionId()))
                    .findFirst()
                    .ifPresent(auction -> {
                        bidDto.setAuction(auction);

                        // Find and set car associated with this auction
                        String carId = auction.getCar().getId();
                        cars.stream()
                                .filter(car -> car.getId().equals(carId))
                                .findFirst()
                                .ifPresent(bidDto::setCar);
                    });

            bidDtos.add(bidDto);
        }

        return bidDtos;
    }


    // car routes
    @GetMapping("/dashboard/create-car")
    public String createCarPage() {
        return "car/car_form";
    }

    @GetMapping("/dashboard/cars")
    public String carsListPage(Model model) throws IOException {
        List<Car> cars = carService.getAllActiveCars();
        model.addAttribute("cars",cars);
        return "car/cars";
    }

    @GetMapping("/dashboard/edit-car/{id}")
    public String editCarPage(@PathVariable String id, Model model) throws IOException {
        Optional<Car> car = carService.getCarById(id);
        if (car.isPresent()) {
            model.addAttribute("car", car.get());
            return "car/edit_car";
        }
        return "redirect:/dashboard/cars";
    }

    //user routes
    @GetMapping("/dashboard/create-user")
    public String createUser() {
        return "user/create_user";
    }

    @GetMapping("/dashboard/users")
    public String userListPage(Model model) throws IOException {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users",users);
        return "user/users";
    }

    @GetMapping("/dashboard/edit-user/{id}")
    public String editUserPage(@PathVariable String id, Model model) throws IOException {
        Optional<Car> car = carService.getCarById(id);
        if (car.isPresent()) {
            model.addAttribute("car", car.get());
            return "user/edt_user";
        }
        return "redirect:/dashboard/users";
    }

    //advertisment
    @GetMapping("/dashboard/create-advertisement")
    public String createAdvertisement() {
        return "advertisements/create_advertisement";
    }

    @GetMapping("/dashboard/advertisements")
    public String advertisementListPage(Model model) throws IOException {
        List<Advertisement> users = advertisementService.getAllAds();
        model.addAttribute("users",users);
        return "advertisements/advertisements";
    }

    @GetMapping("/dashboard/edit-advertisement/{id}")
    public String editAdvertisementPage(@PathVariable String id, Model model) throws IOException {
        Optional<Advertisement> advertisement = advertisementService.getAdById(id);
        if (advertisement.isPresent()) {
            model.addAttribute("advertisement", advertisement.get());
            return "advertisements/edit_advertisement";
        }
        return "redirect:/dashboard/users";
    }

    //auctions
    @GetMapping("/dashboard/create-auction")
    public String createAuction(Model model) throws IOException {
        List<Car> cars = carService.getAllActiveCars();
        model.addAttribute("cars",cars);
        return "auctions/create_auction";
    }

    @GetMapping("/dashboard/auctions")
    public String auctionListPage(Model model) throws IOException {
        List<Auction> auctions = auctionService.getAllAuctions();
        model.addAttribute("auctions",auctions);
        return "auctions/auctions";
    }

    @GetMapping("/dashboard/edit-auction/{id}")
    public String editAuctionPage(@PathVariable String id, Model model) throws IOException {
        Optional<Auction> auction = auctionService.getAuctionById(id);
        if (auction.isPresent()) {
            model.addAttribute("auction", auction.get());
            return "auctions/edit_auction";
        }
        return "redirect:/dashboard/auctions";
    }
    //logout
    @GetMapping("/logout")
    public String logout(){
        return "/logout";
    }
}