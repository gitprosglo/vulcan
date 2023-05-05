pragma solidity >=0.8.13 <0.9.0;

import {Test, expect, console, json, JsonObject, vulcan} from "../../src/test.sol";

contract JsonTest is Test {
    using vulcan for *;

    struct Foo {
        string foo;
    }

    function testParseObject() external {
        string memory jsonStr = '{"foo":"bar"}';
        Foo memory obj = abi.decode(json.getObject(jsonStr), (Foo));
        expect(obj.foo).toEqual("bar");
    }

    function testParseObjectStruct() external {
        JsonObject memory jsonObject = json.create().set("foo", string("bar"));
        Foo memory obj = abi.decode(json.getObject(jsonObject), (Foo));
        expect(obj.foo).toEqual("bar");
    }

    function testParseUint() external {
        expect(json.getUint('{"foo":123}', ".foo")).toEqual(123);
    }

    function testParseUintArray() external {
        uint256[] memory arr = json.getUintArray('{"foo":[123]}', ".foo");
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual(123);
    }

    function testParseInt() external {
        expect(json.getInt('{"foo":-123}', ".foo")).toEqual(-123);
    }

    function testParseIntArray() external {
        int256[] memory arr = json.getIntArray('{"foo":[-123]}', ".foo");
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual(-123);
    }

    function testParseBool() external {
        expect(json.getBool('{"foo":true}', ".foo")).toEqual(true);
    }

    function testParseBoolArray() external {
        bool[] memory arr = json.getBoolArray('{"foo":[true]}', ".foo");
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual(true);
    }

    function testParseAddress() external {
        expect(json.getAddress('{"foo":"0x0000000000000000000000000000000000000001"}', ".foo")).toEqual(address(1));
    }

    function testParseAddressArray() external {
        address[] memory arr = json.getAddressArray('{"foo":["0x0000000000000000000000000000000000000001"]}', ".foo");
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual(address(1));
    }

    function testParseString() external {
        expect(json.getString('{"foo":"bar"}', ".foo")).toEqual("bar");
    }

    function testParseStringArray() external {
        string[] memory arr = json.getStringArray('{"foo":["bar"]}', ".foo");
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual("bar");
    }

    function testParseBytes() external {
        expect(json.getBytes('{"foo":"0x1234"}', ".foo")).toEqual(hex"1234");
    }

    function testParseBytesArray() external {
        bytes[] memory arr = json.getBytesArray('{"foo":["0x1234"]}', ".foo");
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual(hex"1234");
    }

    function testParseBytes32() external {
        expect(
            json.getBytes32('{"foo":"0x0000000000000000000000000000000000000000000000000000000000000001"}', ".foo")
        ).toEqual(bytes32(uint256(1)));
    }

    function testParseBytes32Array() external {
        bytes32[] memory arr = json.getBytes32Array(
            '{"foo":["0x0000000000000000000000000000000000000000000000000000000000000001"]}', ".foo"
        );
        expect(arr.length).toEqual(1);
        expect(arr[0]).toEqual(bytes32(uint256(1)));
    }

    function testSetBool() external {
        JsonObject memory obj = json.create();
        obj.set("foo", true);
        expect(obj.serialized).toEqual('{"foo":true}');
    }

    function testSetUint() external {
        JsonObject memory obj = json.create();
        obj.set("foo", uint256(123));
        expect(obj.serialized).toEqual('{"foo":123}');
    }

    function testSetInt() external {
        JsonObject memory obj = json.create();
        obj.set("foo", int256(-123));
        expect(obj.serialized).toEqual('{"foo":-123}');
    }

    function testSetAddress() external {
        JsonObject memory obj = json.create();
        obj.set("foo", address(1));
        expect(obj.serialized).toEqual('{"foo":"0x0000000000000000000000000000000000000001"}');
    }

    function testSetBytes32() external {
        JsonObject memory obj = json.create();
        obj.set("foo", bytes32(uint256(1)));
        expect(obj.serialized).toEqual('{"foo":"0x0000000000000000000000000000000000000000000000000000000000000001"}');
    }

    function testSetString() external {
        JsonObject memory obj = json.create();
        obj.set("foo", string("bar"));
        expect(obj.serialized).toEqual('{"foo":"bar"}');
    }

    function testSetBytes() external {
        JsonObject memory obj = json.create();
        obj.set("foo", abi.encodePacked(uint256(1)));
        expect(obj.serialized).toEqual('{"foo":"0x0000000000000000000000000000000000000000000000000000000000000001"}');
    }

    function testSetObject() external {
        JsonObject memory a = json.create();
        JsonObject memory b = json.create();
        a.set("foo", abi.encodePacked(uint256(1)));
        b.set("bar", a);
        expect(b.serialized).toEqual(
            '{"bar":{"foo":"0x0000000000000000000000000000000000000000000000000000000000000001"}}'
        );
    }
}
