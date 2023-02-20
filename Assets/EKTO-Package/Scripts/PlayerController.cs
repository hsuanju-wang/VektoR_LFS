using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    void Start()
    {

    }

    private void Update()
    {
        Vector3 v = transform.localRotation *  EktoVRManager.S.ekto.GetSystemUserVelocity();
        transform.localPosition += v * Time.deltaTime;
        Vector3 offset = new Vector3(transform.localPosition.x, -EktoVRManager.S.ekto.GetBootToFloorOffset(), transform.localPosition.z);
        transform.localPosition = offset;
    }
}
